import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/email_service.dart';

class CheckoutView extends StatefulWidget {
  final List<Product> cartItems;

  CheckoutView({required this.cartItems});

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String address = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (value) => name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address'),
                    onChanged: (value) => address = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            isLoading ? CircularProgressIndicator() : ElevatedButton(
              onPressed: _checkout,
              child: Text('Complete Purchase (\$$totalAmount)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkout() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser;
      CollectionReference orders = Firestore.instance.collection('orders');

      await orders.add({
        'userId': user.uid,
        'items': widget.cartItems.map((item) => item.toMap()).toList(),
        'totalAmount': widget.cartItems.fold(0, (sum, item) => sum + item.price),
        'date': DateTime.now().toIso8601String(),
      });

      await Firestore.instance.collection('users').document(user.uid).updateData({
        'walletBalance': FieldValue.increment(-widget.cartItems.fold(0, (sum, item) => sum + item.price)),
      });

      List<String> productLinks = [];
      for (Product item in widget.cartItems) {
        StorageReference ref = FirebaseStorage.instance.ref().child(item.productFile);
        String url = await ref.getDownloadURL();
        productLinks.add('${item.name}: $url');
      }

      await EmailService().sendEmail(
        email,
        'Your Purchase from Our Shop',
        'Thank you for your purchase!\n\nHere are your download links:\n\n${productLinks.join('\n')}',
      );

      setState(() {
        isLoading = false;
        widget.cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase successful! Check your email for download links.')));
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to complete purchase. Please try again.')));
    }
  }
}
