import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/features/announcements/data/models/announcement_model.dart';
import 'package:platform_core_frontend/features/announcements/presentation/add_announcement_screen.dart';
import 'package:platform_core_frontend/features/announcements/presentation/announcements_screen.dart';
import 'package:platform_core_frontend/features/announcements/presentation/edit_announcement_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/auth_landing_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/login_password_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/login_phone_screen.dart';
import 'package:platform_core_frontend/features/auth/presentation/otp_screen.dart';
import 'package:platform_core_frontend/features/finance/presentation/add_collection_screen.dart';
import 'package:platform_core_frontend/features/finance/presentation/add_expense_screen.dart';
import 'package:platform_core_frontend/features/main_shell/presentation/main_shell_screen.dart';
import 'package:platform_core_frontend/features/masjid_request/presentation/masjid_request_form_screen.dart';
import 'package:platform_core_frontend/features/namaz_time/presentation/update_namaz_time_screen.dart';
import 'package:platform_core_frontend/features/projects/data/models/project_model.dart';
import 'package:platform_core_frontend/features/projects/presentation/add_project_screen.dart';
import 'package:platform_core_frontend/features/projects/presentation/edit_project_screen.dart';
import 'package:platform_core_frontend/features/projects/presentation/project_detail_screen.dart';
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
      builder: (context, state) => const MasjidRequestFormScreen(),
    ),
    GoRoute(
      path: '/finance/add-collection',
      builder: (context, state) => const AddCollectionScreen(),
    ),
    GoRoute(
      path: '/finance/add-expense',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/announcements',
      builder: (context, state) => const AnnouncementsScreen(),
    ),
    GoRoute(
      path: '/announcements/add',
      builder: (context, state) => const AddAnnouncementScreen(),
    ),
    GoRoute(
      path: '/announcements/:id/edit',
      builder: (context, state) {
        final announcementId = state.pathParameters['id'] ?? '';
        final extra = state.extra;
        final announcement = extra is AnnouncementModel ? extra : null;
        return EditAnnouncementScreen(
          announcementId: announcementId,
          announcement: announcement,
        );
      },
    ),
    GoRoute(
      path: '/namaz-time/update',
      builder: (context, state) {
        final extra = state.extra;
        String? masjidId;
        if (extra is Map<String, dynamic>) {
          masjidId = extra['masjidId']?.toString();
        }
        return UpdateNamazTimeScreen(masjidId: masjidId);
      },
    ),
    GoRoute(
      path: '/projects/add',
      builder: (context, state) => const AddProjectScreen(),
    ),
    GoRoute(
      path: '/projects/:id/edit',
      builder: (context, state) {
        final projectId = state.pathParameters['id'] ?? '';
        final extra = state.extra;
        final project = extra is ProjectModel ? extra : null;
        return EditProjectScreen(
          projectId: projectId,
          initialProject: project,
        );
      },
    ),
    GoRoute(
      path: '/projects/:id',
      builder: (context, state) {
        final projectId = state.pathParameters['id'] ?? '';
        final extra = state.extra;
        final project = extra is ProjectModel ? extra : null;
        return ProjectDetailScreen(
          projectId: projectId,
          initialProject: project,
        );
      },
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
