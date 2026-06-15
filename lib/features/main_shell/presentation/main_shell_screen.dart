import 'package:flutter/material.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  static const List<_MainTab> _tabs = <_MainTab>[
    _MainTab(label: 'Home', icon: Icons.home_outlined),
    _MainTab(label: 'Finance', icon: Icons.account_balance_wallet_outlined),
    _MainTab(label: 'Projects', icon: Icons.task_alt_outlined),
    _MainTab(label: 'Community', icon: Icons.groups_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTab = _tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Masjid Core')),
      body: Center(
        child: Text(
          '${selectedTab.label} placeholder',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
