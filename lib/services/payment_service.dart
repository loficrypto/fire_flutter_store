import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  final String apiUrl = 'https://apirone.com/api/v2/invoices';

  Future<Map<String, dynamic>> createInvoice(double amount, String currency, String callbackUrl) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'callback': callbackUrl,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create invoice');
    }
  }

  Future<Map<String, dynamic>> checkPaymentStatus(String invoiceId) async {
    final response = await http.get(Uri.parse('$apiUrl/$invoiceId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check payment status');
    }
  }

  Future<void> forwardPayment(String invoiceId, String destinationAddress) async {
    final response = await http.post(
      Uri.parse('$apiUrl/$invoiceId/forward'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'address': destinationAddress,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to forward payment');
    }
  }
}
