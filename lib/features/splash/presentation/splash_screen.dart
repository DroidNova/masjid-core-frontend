import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
import 'package:platform_core_frontend/shared/widgets/loading_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage;

  final TokenStorage? _tokenStorage;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final TokenStorage _tokenStorage = widget._tokenStorage ?? TokenStorage();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final hasToken = await _tokenStorage.hasAccessToken();

    if (!mounted) return;

    context.go(hasToken ? '/main' : '/auth');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Masjid Core',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const LoadingView(),
            ],
          ),
        ),
      ),
    );
  }
}
