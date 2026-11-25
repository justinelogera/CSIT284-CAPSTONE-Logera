import 'database.dart';

class Loan {
  static final ref = db.ref('loans');

  final String id;
  final String bookId;
  final String title;
  final String studentId;
  final DateTime borrowedAt;
  final DateTime dueDate;
  final DateTime? returnedAt;

  const Loan({
    required this.id,
    required this.bookId,
    required this.title,
    required this.studentId,
    required this.borrowedAt,
    required this.dueDate,
    this.returnedAt,
  });

  factory Loan.fromMap(String id, Map<String, dynamic> d) => Loan(
        id: id,
        bookId: d['bookId'] as String,
        title: d['title'] as String,
        studentId: d['studentId'] as String,
        borrowedAt: dateFrom(d['borrowedAt'])!,
        dueDate: dateFrom(d['dueDate'])!,
        returnedAt: dateFrom(d['returnedAt']),
      );

  bool get isActive => returnedAt == null;

  /// Borrowing history, newest first.
  static Stream<List<Loan>> watchAll() => ref.onValue.map((e) =>
      entriesOf(e.snapshot.value).map((x) => Loan.fromMap(x.key, x.value)).toList()
        ..sort((a, b) => b.borrowedAt.compareTo(a.borrowedAt)));
}