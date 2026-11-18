import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_title.dart';
import 'book_details_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final books = dummyBooks.where((b) => b.matches(query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Book Borrowing Tracker')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SearchBar(
            hintText: 'Search title or author',
            leading: const Icon(Icons.search),
            onChanged: (v) => setState(() => query = v),
          ),
        ),
        Expanded(
          child: books.isEmpty
              ? const Center(child: Text('No books found'))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, i) => BookTile(
                    book: books[i],
                    // Navigate to the detail screen, refresh the list when coming back.
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BookDetailScreen(book: books[i])),
                      );
                      setState(() {});
                    },
                  ),
                ),
        ),
      ]),
    );
  }
}