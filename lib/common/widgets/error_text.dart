import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String text;
  const ErrorText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}

class ErrorScreen extends StatelessWidget {
  final String text;
  const ErrorScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
