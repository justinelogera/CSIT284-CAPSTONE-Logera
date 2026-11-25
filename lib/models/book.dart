import 'database.dart';
import 'date_text.dart';
import 'loan.dart';

class Book {
  static const loanDays = 14;
  static final _books = db.ref('books');

  final String id;
  final String title;
  final String author;
  final String category;
  final String? borrowedBy;
  final String? loanId;
  final DateTime? dueDate;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    this.borrowedBy,
    this.loanId,
    this.dueDate,
  });

  factory Book.fromMap(String id, Map<String, dynamic> d) => Book(
        id: id,
        title: d['title'] as String,
        author: d['author'] as String,
        category: (d['category'] as String?) ?? '',
        borrowedBy: d['borrowedBy'] as String?,
        loanId: d['loanId'] as String?,
        dueDate: dateFrom(d['dueDate']),
      );

  bool get isBorrowed => borrowedBy != null;
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now());
  String get dueText => dueDate == null ? '' : dueDate!.ymd;
  bool matches(String query) =>
      '$title $author'.toLowerCase().contains(query.toLowerCase());

  // ---------- READ ----------

  static Stream<List<Book>> watchAll() => _books.onValue.map((e) =>
      entriesOf(e.snapshot.value).map((x) => Book.fromMap(x.key, x.value)).toList()
        ..sort((a, b) => a.title.compareTo(b.title)));

  static Stream<Book?> watchOne(String id) => _books.child(id).onValue.map((e) {
        final v = e.snapshot.value;
        if (v is! Map) return null; // deleted
        return Book.fromMap(id, Map<String, dynamic>.from(v));
      });

  // ---------- CREATE ----------

  static Future<void> add(
          {required String title, required String author, required String category}) =>
      _books.push().set({'title': title, 'author': author, 'category': category});

  /// Seeds 10 dummy books once, if the database is empty.
  static Future<void> seed() async {
    if ((await _books.get()).exists) return;
    const list = [
      ['Clean Code', 'Robert C. Martin', 'Programming'],
      ['The Pragmatic Programmer', 'Andrew Hunt', 'Programming'],
      ['Introduction to Algorithms', 'Thomas H. Cormen', 'Computer Science'],
      ['Design Patterns', 'Erich Gamma', 'Programming'],
      ['Database System Concepts', 'Abraham Silberschatz', 'Databases'],
      ['Computer Networking', 'James Kurose', 'Networking'],
      ['Operating System Concepts', 'Abraham Silberschatz', 'Computer Science'],
      ['Noli Me Tangere', 'Jose Rizal', 'Literature'],
      ['El Filibusterismo', 'Jose Rizal', 'Literature'],
      ['Atomic Habits', 'James Clear', 'Self-Help'],
    ];
    final data = <String, Object?>{};
    for (final b in list) {
      data[_books.push().key!] = {'title': b[0], 'author': b[1], 'category': b[2]};
    }
    await _books.set(data);
  }

  // ---------- UPDATE ----------

  Future<void> edit(
          {required String title, required String author, required String category}) =>
      _books.child(id).update({'title': title, 'author': author, 'category': category});

  /// Creates the loan and marks the book as taken in one atomic update.
  Future<void> borrow(String sid) async {
    final now = DateTime.now();
    final due = now.add(const Duration(days: loanDays)).millisecondsSinceEpoch;
    final loanKey = Loan.ref.push().key!;
    await db.ref().update({
      'loans/$loanKey': {
        'bookId': id,
        'title': title,
        'studentId': sid,
        'borrowedAt': now.millisecondsSinceEpoch,
        'dueDate': due,
      },
      'books/$id/borrowedBy': sid,
      'books/$id/dueDate': due,
      'books/$id/loanId': loanKey,
    });
  }

  /// Closes the loan and frees the book (null removes the field).
  Future<void> giveBack() async {
    if (loanId == null) return;
    await db.ref().update({
      'loans/$loanId/returnedAt': DateTime.now().millisecondsSinceEpoch,
      'books/$id/borrowedBy': null,
      'books/$id/dueDate': null,
      'books/$id/loanId': null,
    });
  }

  // ---------- DELETE ----------

  Future<void> delete() => _books.child(id).remove();
}