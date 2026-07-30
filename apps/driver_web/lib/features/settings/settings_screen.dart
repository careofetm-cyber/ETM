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
    final useWideLayout = width > 700;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : useWideLayout
            ? _buildWideLayout(cs, padding, themeMode)
            : _buildNarrowLayout(cs, padding, themeMode);
  }

  Widget _buildWideLayout(ColorScheme cs, double padding, AppThemeMode themeMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              _buildUserCard(cs),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              _buildAppearanceSection(cs, themeMode),
              const SizedBox(height: 16),
              _buildAboutSection(cs),
              const SizedBox(height: 16),
              _buildAccountSection(cs),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(ColorScheme cs, double padding, AppThemeMode themeMode) {
    return ListView(
      padding: EdgeInsets.all(padding),
      children: [
        _buildUserCard(cs),
        const SizedBox(height: 24),
        _buildAppearanceSection(cs, themeMode),
        const SizedBox(height: 24),
        _buildAboutSection(cs),
        const SizedBox(height: 24),
        _buildAccountSection(cs),
      ],
    );
  }

  Widget _buildUserCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'D',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(_userName,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _userRole[0].toUpperCase() + _userRole.substring(1),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(ColorScheme cs, AppThemeMode themeMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appearance',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurfaceVariant)),
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
      ],
    );
  }

  Widget _buildAboutSection(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurfaceVariant)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.info_outline, color: cs.onPrimaryContainer, size: 20),
                ),
                title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(8)),
                  child: Text('1.0.0',
                      style:
                          TextStyle(color: cs.onPrimaryContainer, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              Divider(height: 1, indent: 56, color: cs.outlineVariant),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.business, color: Colors.teal.shade700, size: 20),
                ),
                title: const Text('Organization', style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Text('ETM',
                      style: TextStyle(
                          color: Colors.teal.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurfaceVariant)),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.logout, color: Colors.red.shade600, size: 20),
            ),
            title: Text('Logout', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w500)),
            onTap: () async {
              final prefs = await ref.read(sharedPreferencesProvider.future);
              await prefs.clear();
              if (context.mounted) context.go('/login');
            },
          ),
        ),
      ],
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
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.w500)),
      trailing: selected
          ? Icon(Icons.check_circle, color: cs.primary)
          : Icon(Icons.circle_outlined, color: cs.outline),
      onTap: onTap,
    );
  }
}
