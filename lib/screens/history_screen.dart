import 'package:flutter/material.dart';

import '../models/loan.dart';
import '../widgets/loan_title.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Borrowing History')),
        body: StreamBuilder<List<Loan>>(
          stream: Loan.watchAll(),
          builder: (context, snap) {
            if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final loans = snap.data!;
            if (loans.isEmpty) return const Center(child: Text('No borrowing history yet'));
            return ListView(children: [for (final l in loans) LoanTile(l)]);
          },
        ),
      );
}