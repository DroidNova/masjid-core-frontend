import 'package:flutter/material.dart';
import 'package:platform_core_frontend/core/routing/app_router.dart';
import 'package:platform_core_frontend/core/widgets/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Login',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Login flow will be added in the next step.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text('Go to Register'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            child: const Text('Skip to Home Placeholder'),
          ),
        ],
      ),
    );
  }
}
