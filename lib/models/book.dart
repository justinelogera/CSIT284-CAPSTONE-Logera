class Book {
  final String title;
  final String author;
  final String category;
  bool isBorrowed;
  DateTime? dueDate;

  Book({
    required this.title,
    required this.author,
    required this.category,
    this.isBorrowed = false,
    this.dueDate,
  });

  void borrow() {
    isBorrowed = true;
    dueDate = DateTime.now().add(const Duration(days: 14));
  }

  void giveBack() {
    isBorrowed = false;
    dueDate = null;
  }

  /// e.g. 2026-12-02
  String get dueText {
    final d = dueDate;
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  bool matches(String query) =>
      '$title $author'.toLowerCase().contains(query.toLowerCase());
}

/// 10 dummy books (hardcoded list, no backend yet).
final List<Book> dummyBooks = [
  Book(title: 'Clean Code', author: 'Robert C. Martin', category: 'Programming'),
  Book(title: 'The Pragmatic Programmer', author: 'Andrew Hunt', category: 'Programming'),
  Book(title: 'Introduction to Algorithms', author: 'Thomas H. Cormen', category: 'Computer Science'),
  Book(title: 'Design Patterns', author: 'Erich Gamma', category: 'Programming'),
  Book(title: 'Database System Concepts', author: 'Abraham Silberschatz', category: 'Databases'),
  Book(title: 'Computer Networking', author: 'James Kurose', category: 'Networking'),
  Book(title: 'Operating System Concepts', author: 'Abraham Silberschatz', category: 'Computer Science'),
  Book(title: 'Noli Me Tangere', author: 'Jose Rizal', category: 'Literature'),
  Book(
    title: 'El Filibusterismo',
    author: 'Jose Rizal',
    category: 'Literature',
    isBorrowed: true,
    dueDate: DateTime.now().add(const Duration(days: 7)),
  ),
  Book(title: 'Atomic Habits', author: 'James Clear', category: 'Self-Help'),
];