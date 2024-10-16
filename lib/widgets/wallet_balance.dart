import 'package:flutter/material.dart';

class WalletBalance extends StatelessWidget {
  final double balance;

  const WalletBalance({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Wallet Balance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("\$$balance", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
