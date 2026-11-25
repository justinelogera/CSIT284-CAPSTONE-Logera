import 'package:flutter/material.dart';

import '../models/date_text.dart';
import '../models/loan.dart';

class LoanTile extends StatelessWidget {
  final Loan loan;
  const LoanTile(this.loan, {super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(loan.title),
        subtitle: Text(
            'Student ${loan.studentId}\nBorrowed ${loan.borrowedAt.ymd} · Due ${loan.dueDate.ymd}'),
        isThreeLine: true,
        trailing: loan.isActive
            ? const Chip(label: Text('Active'))
            : Text('Returned\n${loan.returnedAt!.ymd}', textAlign: TextAlign.right),
      );
}