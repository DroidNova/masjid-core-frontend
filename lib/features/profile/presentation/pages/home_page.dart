import 'package:flutter/material.dart';
import 'package:platform_core_frontend/core/routing/app_router.dart';
import 'package:platform_core_frontend/core/widgets/app_scaffold.dart';
import 'package:platform_core_frontend/features/auth/presentation/auth_scope.dart';
import 'package:platform_core_frontend/features/auth/presentation/controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController? _authController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authController ??= AuthScope.of(context);
  }

  Future<void> _logout() async {
    await _authController!.logout();
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authController = _authController!;

    return ListenableBuilder(
      listenable: authController,
      builder: (context, _) {
        final user = authController.state.user;

        return AppScaffold(
          title: 'Home',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                user?.displayName ?? user?.email ?? 'Authenticated user',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (user != null) ...[
                const SizedBox(height: 8),
                Text('Email: ${user.email}'),
                const SizedBox(height: 4),
                Text('Roles: ${user.roles.join(', ')}'),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: authController.state.isSubmitting ? null : _logout,
                child: authController.state.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Logout'),
              ),
            ],
          ),
        );
      },
    );
  }
}
