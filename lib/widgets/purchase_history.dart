import 'package:flutter/material.dart';

class PurchaseHistory extends StatelessWidget {
  final List<Map<String, dynamic>> purchases;

  PurchaseHistory({required this.purchases});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Purchases', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...purchases.map((purchase) => ListTile(
              title: Text(purchase['productName']),
              subtitle: Text('Amount: \$${purchase['amount']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Implement download functionality
                },
                child: Text('Download'),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
