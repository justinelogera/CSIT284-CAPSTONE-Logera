import 'package:flutter/material.dart';

import '../models/book.dart';
import 'book_form_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late final Stream<Book?> stream = Book.watchOne(widget.book.id);

  Future<String?> askStudentId() {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrow book'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Student ID'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Borrow')),
        ],
      ),
    );
  }

  Future<void> borrow(Book b) async {
    final sid = await askStudentId();
    if (sid != null && sid.isNotEmpty) await b.borrow(sid);
  }

  Future<void> confirmDelete(Book b) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text('Remove "${b.title}" from the library?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await b.delete();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Book?>(
        stream: stream,
        builder: (context, snap) {
          final b = snap.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Book Details'),
              actions: b == null
                  ? null
                  : [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BookFormScreen(book: b))),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                        onPressed: () => confirmDelete(b),
                      ),
                    ],
            ),
            body: b == null
                ? Center(
                    child: snap.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : const Text('Book not found'))
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(b.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('by ${b.author}'),
                      Text('Category: ${b.category}'),
                      const SizedBox(height: 16),
                      Text('Status: ${b.isBorrowed ? 'Borrowed' : 'Available'}'),
                      if (b.isBorrowed) ...[
                        Text('Borrowed by: ${b.borrowedBy}'),
                        Text('Due date: ${b.dueText}${b.isOverdue ? ' (overdue)' : ''}'),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => b.isBorrowed ? b.giveBack() : borrow(b),
                        child: Text(b.isBorrowed ? 'Return' : 'Borrow'),
                      ),
                    ]),
                  ),
          );
        },
      );
}