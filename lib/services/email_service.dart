import 'package:http/http.dart' as http;

class EmailService {
  final String smtpEndpoint = 'smtp-relay.brevo.com';
  final String smtpUsername = 'your-brevo-username';
  final String smtpPassword = 'your-brevo-password';

  Future<void> sendEmail(String to, String subject, String message) async {
    final response = await http.post(
      Uri.parse(smtpEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$smtpUsername:$smtpPassword')),
      },
      body: jsonEncode({
        'to': to,
        'subject': subject,
        'text': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email');
    }
  }
}
