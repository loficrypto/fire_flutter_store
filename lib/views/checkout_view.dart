import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import '../services/email_service.dart';

class CheckoutView extends StatelessWidget {
  final List<Product> cartItems;
  final double walletBalance;
  final double totalAmount;
  final Function(double) updateWalletBalance;

  CheckoutView({
    required this.cartItems,
    required this.walletBalance,
    required this.totalAmount,
    required this.updateWalletBalance,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();

    void _handleCheckout() async {
      if (_formKey.currentState!.validate()) {
        if (walletBalance >= totalAmount) {
          // Update wallet balance
          updateWalletBalance(totalAmount);

          // Create order
          final orderData = {
            'items': cartItems.map((item) => item.name).toList(),
            'totalAmount': totalAmount,
            'date': DateTime.now().toIso8601String(),
          };
          await FirestoreService().setData('orders', orderData);

          // Send email
          final emailContent =
              'Thank you for your purchase! Here are your product links: ${cartItems.map((item) => item.imageUrl).join(', ')}';
          await EmailService().sendEmail(_emailController.text, 'Order Confirmation', emailContent);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase successful!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Insufficient wallet balance.')));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _handleCheckout,
                child: Text('Complete Purchase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
