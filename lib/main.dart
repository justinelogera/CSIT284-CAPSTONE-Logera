import 'package:flutter/material.dart';

import 'screens/book_list_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Book Borrowing Tracker',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const BookListScreen(),
      );
}