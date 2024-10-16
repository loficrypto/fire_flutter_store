import 'package:flutter/material.dart';
import 'package:ecommerce_web_app/widgets/admin_orders.dart';
import 'package:ecommerce_web_app/widgets/admin_products.dart';
import 'package:ecommerce_web_app/widgets/admin_users.dart';
import 'package:ecommerce_web_app/widgets/admin_emails.dart';

class AdminView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Manage Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            AdminOrders(),
            SizedBox(height: 16),
            Text(
              'Manage Products',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            AdminProducts(),
            SizedBox(height: 16),
            Text(
              'Manage Users',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            AdminUsers(),
            SizedBox(height: 16),
            Text(
              'Send Emails',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            AdminEmails(),
          ],
        ),
      ),
    );
  }
}
