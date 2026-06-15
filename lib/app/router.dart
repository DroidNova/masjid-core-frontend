import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/features/auth/presentation/auth_landing_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/login_phone_screen.dart';
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
      path: '/masjid-request',
      builder: (context, state) => const MasjidRequestPlaceholderScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainShellScreen(),
    ),
  ],
);
