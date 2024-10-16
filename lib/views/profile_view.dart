import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/profile_details.dart';
import '../widgets/purchase_history.dart';
import '../widgets/top_up_history.dart';
import '../widgets/wallet_balance.dart';
import '../widgets/transactions.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Map<String, dynamic> _profileData = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final user = Provider.of<FirebaseAuthService>(context, listen: false).currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _profileData = userDoc.data()!;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileDetails(user: user, profileData: _profileData),
                  WalletBalance(balance: _profileData['walletBalance']),
                  PurchaseHistory(purchases: _profileData['purchases']),
                  TopUpHistory(topUps: _profileData['topUps']),
                  Transactions(transactions: _profileData['transactions']),
                ],
              ),
            ),
    );
  }
}
