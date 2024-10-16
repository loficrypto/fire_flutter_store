import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_service.dart';
import '../models/product.dart';

class CartView extends StatelessWidget {
  final List<Product> cartItems;
  final Function(int) handleRemoveFromCart;

  CartView({required this.cartItems, required this.handleRemoveFromCart});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(child: Text('Your cart is empty.'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: Image.network(product.imageUrl),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => handleRemoveFromCart(index),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (authService.currentUser != null) {
                  Navigator.pushNamed(context, '/checkout');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
              child: Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
