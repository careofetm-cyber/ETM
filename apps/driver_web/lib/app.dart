import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'providers.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/trips/trip_list_screen.dart';
import 'features/trip_detail/trip_detail_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/tracking/tracking_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final isLoggedIn = token != null && token.isNotEmpty;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/dashboard';
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
          GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/trips', builder: (_, __) => const TripListScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
          GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
        ],
      ),
      GoRoute(
        path: '/trip/:id',
        builder: (_, state) => TripDetailScreen(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tracking/:id',
        builder: (_, state) => TrackingScreen(tripId: state.pathParameters['id']!),
      ),
    ],
  );
});

class DriverWebApp extends ConsumerWidget {
  const DriverWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeModeValue = ref.watch(themeModeProvider);

    ThemeMode themeMode = ThemeMode.system;
    switch (themeModeValue) {
      case AppThemeMode.light:
        themeMode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        themeMode = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: 'ETM Driver Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 12),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 12),
        ),
      ),
      themeMode: themeMode,
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
  static const _tabs = ['/dashboard', '/trips', '/notifications', '/profile', '/settings'];
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://etm-gp12.onrender.com/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        final resp = await dio.get(
          '/notifications',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        final notifications = resp.data is List ? resp.data : (resp.data['data'] ?? []);
        if (mounted) {
          setState(() {
            _unreadCount = notifications.where((n) => n['isRead'] != true).length;
          });
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 800;
    final titles = {
      '/dashboard': 'Dashboard',
      '/trips': 'My Trips',
      '/profile': 'Profile',
      '/settings': 'Settings',
      '/notifications': 'Notifications',
    };

    return Scaffold(
      body: Row(
        children: [
          if (!isCompact)
            NavigationRail(
              selectedIndex: _tabs.indexOf(currentPath) >= 0 ? _tabs.indexOf(currentPath) : 0,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.local_shipping, color: cs.onPrimaryContainer, size: 28),
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: IconButton(
                      icon: Badge(
                        isLabelVisible: _unreadCount > 0,
                        label: _unreadCount > 99 ? const Text('99+') : Text('$_unreadCount'),
                        child: const Icon(Icons.notifications_outlined),
                      ),
                      onPressed: () async {
                        await context.push('/notifications');
                        _loadUnreadCount();
                      },
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: Text('Trips')),
                NavigationRailDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: Text('Alerts')),
                NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                NavigationRailDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: Text('Settings')),
              ],
              onDestinationSelected: (i) => context.go(_tabs[i]),
              backgroundColor: cs.surface,
              selectedIconTheme: IconThemeData(color: cs.onPrimaryContainer),
              unselectedIconTheme: IconThemeData(color: cs.onSurfaceVariant),
              selectedLabelTextStyle: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w600),
              unselectedLabelTextStyle: TextStyle(color: cs.onSurfaceVariant),
            ),
          if (!isCompact) const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                if (isCompact)
                  AppBar(
                    leading: Builder(
                      builder: (ctx) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                    title: Text(titles[currentPath] ?? 'ETM Driver'),
                    centerTitle: false,
                    actions: [
                      IconButton(
                        icon: Badge(
                          isLabelVisible: _unreadCount > 0,
                          label: _unreadCount > 99 ? const Text('99+') : Text('$_unreadCount'),
                          child: const Icon(Icons.notifications_outlined),
                        ),
                        onPressed: () async {
                          await context.push('/notifications');
                          _loadUnreadCount();
                        },
                      ),
                    ],
                  ),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
      drawer: isCompact
          ? Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_shipping, color: cs.onPrimaryContainer, size: 32),
                          const SizedBox(width: 12),
                          Text('ETM Driver', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onPrimaryContainer)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DrawerItem(icon: Icons.dashboard_outlined, label: 'Dashboard', selected: currentPath == '/dashboard', onTap: () { Navigator.pop(context); context.go('/dashboard'); }),
                    _DrawerItem(icon: Icons.route_outlined, label: 'My Trips', selected: currentPath == '/trips', onTap: () { Navigator.pop(context); context.go('/trips'); }),
                    _DrawerItem(icon: Icons.notifications_outlined, label: 'Notifications', selected: currentPath == '/notifications', onTap: () { Navigator.pop(context); context.go('/notifications'); }, badge: _unreadCount),
                    _DrawerItem(icon: Icons.person_outline, label: 'Profile', selected: currentPath == '/profile', onTap: () { Navigator.pop(context); context.go('/profile'); }),
                    _DrawerItem(icon: Icons.tune_outlined, label: 'Settings', selected: currentPath == '/settings', onTap: () { Navigator.pop(context); context.go('/settings'); }),
                    const Spacer(),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  const _DrawerItem({required this.icon, required this.label, required this.selected, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: selected ? cs.primary : cs.onSurfaceVariant),
      title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: selected ? cs.primary : null)),
      selected: selected,
      selectedTileColor: cs.primaryContainer.withOpacity(0.3),
      trailing: badge != null && badge! > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)),
              child: Text('$badge', style: TextStyle(color: cs.onPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          : null,
      onTap: onTap,
    );
  }
}
