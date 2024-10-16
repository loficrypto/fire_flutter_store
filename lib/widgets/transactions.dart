import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  final List<dynamic> transactions;

  const Transactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transactions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...transactions.map((transaction) => ListTile(
              title: Text(transaction['type']),
              subtitle: Text("Amount: \$${transaction['amount']}"),
              trailing: Text(transaction['date']),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
