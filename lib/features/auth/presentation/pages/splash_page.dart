import 'package:flutter/material.dart';
import 'package:platform_core_frontend/core/routing/app_router.dart';
import 'package:platform_core_frontend/core/widgets/app_scaffold.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Platform Core Frontend',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Scalable multi-platform foundation initialized.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
