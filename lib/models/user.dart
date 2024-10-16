class User {
  final String id;
  final String email;
  final double walletBalance;
  final List<dynamic> purchases;

  User({
    required this.id,
    required this.email,
    required this.walletBalance,
    required this.purchases,
  });

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      email: data['email'],
      walletBalance: data['walletBalance'],
      purchases: data['purchases'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'walletBalance': walletBalance,
      'purchases': purchases,
    };
  }
}
