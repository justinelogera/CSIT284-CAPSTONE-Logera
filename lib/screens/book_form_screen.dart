import 'package:flutter/material.dart';

import '../models/book.dart';

/// Add a new book, or edit an existing one when [book] is given.
class BookFormScreen extends StatefulWidget {
  final Book? book;
  const BookFormScreen({super.key, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final title = TextEditingController(text: widget.book?.title);
  late final author = TextEditingController(text: widget.book?.author);
  late final category = TextEditingController(text: widget.book?.category);

  @override
  void dispose() {
    title.dispose();
    author.dispose();
    category.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    final t = title.text.trim(), a = author.text.trim(), c = category.text.trim();
    if (widget.book == null) {
      await Book.add(title: t, author: a, category: c);
    } else {
      await widget.book!.edit(title: t, author: a, category: c);
    }
    if (mounted) Navigator.pop(context);
  }

  String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.book == null ? 'Add Book' : 'Edit Book')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: author,
                decoration: const InputDecoration(labelText: 'Author', border: OutlineInputBorder()),
                validator: required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: save, child: const Text('Save')),
            ]),
          ),
        ),
      );
}