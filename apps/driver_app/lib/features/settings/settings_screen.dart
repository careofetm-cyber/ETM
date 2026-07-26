import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _userName = 'Driver';
  String _userRole = 'Driver';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    _userName = prefs.getString('user_name') ?? 'Driver';
    _userRole = prefs.getString('user_role') ?? 'Driver';
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 16.0 : width < 900 ? 24.0 : 32.0;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: EdgeInsets.all(padding),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'D',
                        style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      _userName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _userRole[0].toUpperCase() + _userRole.substring(1),
                        style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        _ThemeOption(
                          title: 'System Default',
                          icon: Icons.brightness_auto,
                          selected: themeMode == AppThemeMode.system,
                          onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.system),
                        ),
                        Divider(height: 1, indent: 56, color: cs.outlineVariant),
                        _ThemeOption(
                          title: 'Light',
                          icon: Icons.light_mode,
                          selected: themeMode == AppThemeMode.light,
                          onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.light),
                        ),
                        Divider(height: 1, indent: 56, color: cs.outlineVariant),
                        _ThemeOption(
                          title: 'Dark',
                          icon: Icons.dark_mode,
                          selected: themeMode == AppThemeMode.dark,
                          onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.dark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info_outline, color: cs.primary),
                          title: const Text('App Version'),
                          trailing: Text(
                            '1.0.0',
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                          ),
                        ),
                        Divider(height: 1, indent: 56, color: cs.outlineVariant),
                        ListTile(
                          leading: Icon(Icons.business, color: cs.primary),
                          title: const Text('Organization'),
                          trailing: Text(
                            'ETM',
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Logout', style: TextStyle(color: Colors.red)),
                      onTap: () async {
                        final prefs = await ref.read(sharedPreferencesProvider.future);
                        await prefs.clear();
                        if (context.mounted) context.go('/login');
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: selected ? cs.primary : cs.onSurfaceVariant),
      title: Text(title),
      trailing: selected
          ? Icon(Icons.check_circle, color: cs.primary)
          : Icon(Icons.circle_outlined, color: cs.outline),
      onTap: onTap,
    );
  }
}
