import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/trips/my_trips_screen.dart';
import 'features/roster/roster_screen.dart';
import 'features/ride/ride_screen.dart';
import 'features/requests/request_adjustment_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/sos/sos_screen.dart';
import 'features/tracking/tracking_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'providers.dart';

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
        builder: (context, state, child) => WebShell(child: child),
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
      GoRoute(
        path: '/sos',
        builder: (_, __) => const SOSScreen(),
      ),
      GoRoute(
        path: '/tracking',
        builder: (_, __) => const TrackingScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
    ],
  );
});

class EmployeeWebApp extends ConsumerWidget {
  const EmployeeWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'ETM Employee Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.zero,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.zero,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}

class WebShell extends StatefulWidget {
  final Widget child;
  const WebShell({super.key, required this.child});

  @override
  State<WebShell> createState() => _WebShellState();
}

class _WebShellState extends State<WebShell> {
  static const _tabs = ['/home', '/trips', '/roster', '/ride', '/profile', '/settings'];
  static const _tabTitles = ['Dashboard', 'My Trips', 'Roster', 'My Ride', 'Profile', 'Settings'];

  int _unreadNotificationCount = 0;
  Timer? _unreadTimer;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', '/home'),
    _NavItem(Icons.route_outlined, Icons.route, 'My Trips', '/trips'),
    _NavItem(Icons.directions_bus_outlined, Icons.directions_bus, 'Ride', '/ride'),
    _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, 'Roster', '/roster'),
    _NavItem(Icons.location_on_outlined, Icons.location_on, 'Tracking', '/tracking'),
    _NavItem(Icons.swap_horiz_outlined, Icons.swap_horiz, 'Requests', '/request-adjustment'),
    _NavItem(Icons.person_outline, Icons.person, 'Profile', '/profile'),
    _NavItem(Icons.notifications_outlined, Icons.notifications, 'Notifications', '/notifications'),
    _NavItem(Icons.warning_amber_outlined, Icons.warning_amber, 'SOS', '/sos'),
    _NavItem(Icons.settings_outlined, Icons.settings, 'Settings', '/settings'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
    _unreadTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchUnreadCount());
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://etm-gp12.onrender.com/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token.isEmpty) return;
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';
      final resp = await dio.get('/notifications/unread-count');
      if (mounted) {
        setState(() => _unreadNotificationCount = resp.data['count'] ?? 0);
      }
    } catch (_) {}
  }

  void _handleNavTap(String path) {
    final isSubRoute = !_tabs.contains(path);
    if (isSubRoute) {
      context.push(path);
    } else {
      context.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _tabs.indexOf(currentPath);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.directions_bus, size: 28),
            const SizedBox(width: 12),
            const Text('ETM Employee Portal'),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _unreadNotificationCount > 0,
              label: Text('$_unreadNotificationCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () async {
              await context.push('/notifications');
              _fetchUnreadCount();
            },
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (context) {
              final userName = 'Employee';
              return CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  userName[0].toUpperCase(),
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(cs, selectedIndex),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildSidebar(ColorScheme cs, int selectedIndex) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isSelected = selectedIndex == index;
                final isSpecial = item.label == 'SOS' || item.label == 'Notifications';
                final notifCount = item.label == 'Notifications' ? _unreadNotificationCount : 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: ListTile(
                    leading: Badge(
                      isLabelVisible: notifCount > 0,
                      label: Text('$notifCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                      child: Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        color: isSelected
                            ? cs.primary
                            : item.label == 'SOS'
                                ? const Color(0xFFDC2626)
                                : cs.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? cs.primary
                            : item.label == 'SOS'
                                ? const Color(0xFFDC2626)
                                : cs.onSurfaceVariant,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: cs.primary.withOpacity(0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    onTap: () => _handleNavTap(item.path),
                  ),
                );
              },
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'ETM v1.0.0',
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;
  const _NavItem(this.icon, this.selectedIcon, this.label, this.path);
}
