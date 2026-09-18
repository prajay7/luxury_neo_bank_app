import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';
import '../design_system/floating_nav_bar.dart';
import 'analytics_screen.dart';
import 'card_studio_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

/// Main navigation shell holding the 4 screens and floating glass bottom navigation.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        onNavigateToCard: () => _onIndexChanged(2),
        onNavigateToAnalytics: () => _onIndexChanged(1),
      ),
      AnalyticsScreen(
        onBack: () => _onIndexChanged(0),
      ),
      CardStudioScreen(
        onBack: () => _onIndexChanged(0),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: ObsidianColors.obsidianBase,
      body: Stack(
        children: [
          // Screen Contents with Animated Fade Transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: screens[_currentIndex],
            ),
          ),

          // Floating Glass Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onIndexChanged: _onIndexChanged,
            ),
          ),
        ],
      ),
    );
  }
}
