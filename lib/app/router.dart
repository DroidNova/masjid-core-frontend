import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/features/auth/presentation/auth_landing_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/login_password_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/login_phone_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/otp_screen.dart';
import 'package:platform_core_frontend/features/main_shell/presentation/main_shell_screen.dart';
import 'package:platform_core_frontend/features/masjid_request/presentation/masjid_request_placeholder_screen.dart';
import 'package:platform_core_frontend/features/splash/presentation/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthLandingScreen(),
    ),
    GoRoute(
      path: '/login-phone',
      builder: (context, state) => const LoginPhoneScreen(),
    ),
    GoRoute(
      path: '/login-password',
      builder: (context, state) {
        final extra = _readExtraMap(state.extra);
        final phone = extra?['phone'];

        if (phone == null || phone.isEmpty) {
          return const _MissingLoginDataScreen();
        }

        return LoginPasswordScreen(phone: phone);
      },
    ),
    GoRoute(
      path: '/login-otp',
      builder: (context, state) {
        final extra = _readExtraMap(state.extra);
        final phone = extra?['phone'];
        final challengeId = extra?['challengeId'];

        if (phone == null ||
            phone.isEmpty ||
            challengeId == null ||
            challengeId.isEmpty) {
          return const _MissingLoginDataScreen();
        }

        return OtpScreen(phone: phone, challengeId: challengeId);
      },
    ),
    GoRoute(
      path: '/masjid-request',
      builder: (context, state) => const MasjidRequestPlaceholderScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainShellScreen(),
    ),
  ],
);

Map<String, String>? _readExtraMap(Object? extra) {
  if (extra is Map<String, String>) return extra;
  if (extra is Map<String, dynamic>) {
    return extra.map(
      (key, value) => MapEntry(key, value?.toString() ?? ''),
    );
  }

  return null;
}

class _MissingLoginDataScreen extends StatelessWidget {
  const _MissingLoginDataScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Login information is missing. Please start again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/login-phone'),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
