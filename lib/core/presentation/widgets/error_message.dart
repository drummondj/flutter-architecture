import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [Icon(Icons.warning_amber_rounded), Text(message)],
    );
  }
}
