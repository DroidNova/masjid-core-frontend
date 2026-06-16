import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_core_frontend/core/permissions/permission_helper.dart';
import 'package:platform_core_frontend/core/storage/session_storage.dart';
import 'package:platform_core_frontend/features/community/presentation/community_screen.dart';
import 'package:platform_core_frontend/features/dashboard/presentation/home_dashboard_screen.dart';
import 'package:platform_core_frontend/features/finance/presentation/finance_screen.dart';
import 'package:platform_core_frontend/features/projects/presentation/projects_screen.dart';
import 'package:platform_core_frontend/shared/widgets/logout_button.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key, SessionStorage? sessionStorage})
      : _sessionStorage = sessionStorage;

  final SessionStorage? _sessionStorage;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;
  late final SessionStorage _sessionStorage =
      widget._sessionStorage ?? SessionStorage();

  @override
  void initState() {
    super.initState();
    _redirectSuperAdmin();
  }

  Future<void> _redirectSuperAdmin() async {
    final user = await _sessionStorage.getUser();
    if (!mounted) return;
    if (PermissionHelper.isSuperAdmin(user)) context.go('/super-admin');
  }

  static const List<_MainTab> _tabs = <_MainTab>[
    _MainTab(label: 'Home', icon: Icons.home_outlined),
    _MainTab(label: 'Finance', icon: Icons.account_balance_wallet_outlined),
    _MainTab(label: 'Projects', icon: Icons.task_alt_outlined),
    _MainTab(label: 'Community', icon: Icons.groups_outlined),
  ];

  static const List<Widget> _screens = <Widget>[
    HomeDashboardScreen(),
    FinanceScreen(),
    ProjectsScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masjid Core'),
        actions: const <Widget>[LogoutButton()],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MainTab {
  const _MainTab({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
