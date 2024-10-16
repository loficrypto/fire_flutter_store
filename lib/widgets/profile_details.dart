import 'package:flutter/material.dart';
import '../models/user.dart';

class ProfileDetails extends StatelessWidget {
  final User user;

  ProfileDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Wallet Balance: \$${user.walletBalance}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
