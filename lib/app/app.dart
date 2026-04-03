import 'package:flutter/material.dart';
import 'package:platform_core_frontend/core/constants/app_constants.dart';
import 'package:platform_core_frontend/core/routing/app_router.dart';
import 'package:platform_core_frontend/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.root,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
