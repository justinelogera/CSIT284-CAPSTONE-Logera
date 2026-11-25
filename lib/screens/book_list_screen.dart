import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_title.dart';
import 'book_details_screen.dart';
import 'book_form_screen.dart';
import 'history_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final stream = Book.watchAll();
  String query = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Book Borrowing Tracker'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'History',
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen())),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add book',
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const BookFormScreen())),
          child: const Icon(Icons.add),
        ),
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
            child: StreamBuilder<List<Book>>(
              stream: stream,
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final books = snap.data!.where((b) => b.matches(query)).toList();
                if (books.isEmpty) return const Center(child: Text('No books found'));
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, i) => BookTile(
                    book: books[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BookDetailScreen(book: books[i])),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      );
}