import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/trips/my_trips_screen.dart';
import 'features/roster/roster_screen.dart';
import 'features/ride/ride_screen.dart';
import 'features/requests/request_adjustment_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final isLoggedIn = token != null && token.isNotEmpty;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/trips', builder: (_, __) => const MyTripsScreen()),
          GoRoute(path: '/roster', builder: (_, __) => const RosterScreen()),
          GoRoute(path: '/ride', builder: (_, __) => const RideScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: '/request-adjustment',
        builder: (_, __) => const RequestAdjustmentScreen(),
      ),
    ],
  );
});

class EmployeeApp extends ConsumerWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'ETM Employee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _tabs = ['/home', '/trips', '/roster', '/ride', '/profile', '/settings'];

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Trips'),
    NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Roster'),
    NavigationDestination(icon: Icon(Icons.directions_bus_outlined), selectedIcon: Icon(Icons.directions_bus), label: 'Ride'),
    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
  ];

  static const _railDestinations = [
    NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
    NavigationRailDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: Text('Trips')),
    NavigationRailDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: Text('Roster')),
    NavigationRailDestination(icon: Icon(Icons.directions_bus_outlined), selectedIcon: Icon(Icons.directions_bus), label: Text('Ride')),
    NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
    NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexOf(currentPath);
    final selectedIndex = index >= 0 ? index : 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => context.go(_tabs[i]),
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.directions_bus, size: 32, color: Color(0xFF2563EB)),
              ),
              destinations: _railDestinations,
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: _destinations,
      ),
    );
  }
}
