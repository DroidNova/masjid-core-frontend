import 'package:flutter/material.dart';
import 'package:platform_core_frontend/core/routing/app_router.dart';
import 'package:platform_core_frontend/core/widgets/app_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Register',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Registration flow placeholder for future implementation.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}
