import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'trips_list_screen.dart';
import 'trip_form_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TripsListScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard,
              color: AppColors.primary,
            ),
            label: 'Tableau de bord',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(
              Icons.list_alt,
              color: AppColors.primary,
            ),
            label: 'Sorties',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(
              Icons.info,
              color: AppColors.primary,
            ),
            label: 'A propos',
          ),
        ],
      ),
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TripFormScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle sortie'),
            )
          : null,
    );
  }
}