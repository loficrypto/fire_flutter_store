import 'package:flutter/material.dart';
import '../services/email_service.dart';

class AdminEmails extends StatefulWidget {
  @override
  _AdminEmailsState createState() => _AdminEmailsState();
}

class _AdminEmailsState extends State<AdminEmails> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _subject = '';
  String _message = '';
  bool _isLoading = false;

  void _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await EmailService().sendEmail(_email, _subject, _message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent successfully!')),
        );
        _formKey.currentState!.reset();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Subject'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject';
              }
              return null;
            },
            onSaved: (value) {
              _subject = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Message'),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a message';
              }
              return null;
            },
            onSaved: (value) {
              _message = value!;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendEmail,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Send Email'),
          ),
        ],
      ),
    );
  }
}
