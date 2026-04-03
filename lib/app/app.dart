import 'package:flutter/material.dart';
import 'package:platform_core_frontend/app/bootstrap.dart';
import 'package:platform_core_frontend/core/routing/app_router.dart';
import 'package:platform_core_frontend/core/theme/app_theme.dart';
import 'package:platform_core_frontend/features/auth/presentation/auth_scope.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.services,
  });

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(
      authController: services.authController,
      adminRepository: services.adminRepository,
    );

    return AuthScope(
      controller: services.authController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: services.config.appName,
        theme: AppTheme.light(),
        initialRoute: AppRoutes.root,
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
