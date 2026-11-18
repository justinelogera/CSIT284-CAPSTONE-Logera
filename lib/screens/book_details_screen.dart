import 'package:flutter/material.dart';

import '../models/book.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('by ${book.author}'),
          Text('Category: ${book.category}'),
          const SizedBox(height: 16),
          Text('Status: ${book.isBorrowed ? 'Borrowed' : 'Available'}'),
          if (book.isBorrowed) Text('Due date: ${book.dueText}'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => setState(() {
              book.isBorrowed ? book.giveBack() : book.borrow();
            }),
            child: Text(book.isBorrowed ? 'Return' : 'Borrow'),
          ),
        ]),
      ),
    );
  }
}