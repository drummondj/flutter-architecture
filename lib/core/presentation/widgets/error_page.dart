import 'package:architecture/core/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorPage({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            const Icon(Icons.error_outline, size: 64),
            Text(message),
            if (onRetry != null)
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
