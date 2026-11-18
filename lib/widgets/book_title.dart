import 'package:flutter/material.dart';

import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  const BookTile({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(book.isBorrowed ? Icons.book_outlined : Icons.menu_book),
        title: Text(book.title),
        subtitle: Text(book.isBorrowed
            ? '${book.author}\nDue ${book.dueText}'
            : book.author),
        isThreeLine: book.isBorrowed,
        trailing: Chip(label: Text(book.isBorrowed ? 'Borrowed' : 'Available')),
        onTap: onTap,
      );
}