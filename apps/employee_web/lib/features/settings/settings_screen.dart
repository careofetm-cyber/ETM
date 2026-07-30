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
  String _userName = '';
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    _userName = prefs.getString('user_name') ?? 'Employee';
    _userRole = prefs.getString('user_role') ?? 'employee';
    setState(() {});
  }

  void _showChangePasswordDialog() {
    final currentPwController = TextEditingController();
    final newPwController = TextEditingController();
    final confirmPwController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentPwController, decoration: const InputDecoration(labelText: 'Current Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline)), obscureText: true),
            const SizedBox(height: 12),
            TextField(controller: newPwController, decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_reset)), obscureText: true),
            const SizedBox(height: 12),
            TextField(controller: confirmPwController, decoration: const InputDecoration(labelText: 'Confirm New Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () async {
              if (newPwController.text != confirmPwController.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                return;
              }
              try {
                final dio = ref.read(dioProvider);
                await dio.put('/auth/change-password', data: {
                  'currentPassword': currentPwController.text,
                  'newPassword': newPwController.text,
                });
                Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed'), backgroundColor: Colors.green));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Change'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 800;
    final horizontalPadding = isWide ? screenWidth * 0.15 : 16.0;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: cs.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isWide ? 32 : 28,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: _userName.isNotEmpty
                      ? Text(_userName[0].toUpperCase(), style: TextStyle(fontSize: isWide ? 28 : 24, color: Colors.white, fontWeight: FontWeight.bold))
                      : Icon(Icons.person, size: isWide ? 28 : 24, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(_userRole.toUpperCase(), style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Appearance'),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDarkMode ? const Color(0xFF6366F1) : const Color(0xFFF59E0B)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: isDarkMode ? const Color(0xFF6366F1) : const Color(0xFFF59E0B), size: 20),
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(isDarkMode ? 'Dark theme active' : 'Light theme active'),
              value: isDarkMode,
              onChanged: (value) { ref.read(themeModeProvider.notifier).state = value; },
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Account'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF59E0B).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.lock_reset, color: Color(0xFFF59E0B), size: 20),
                  ),
                  title: const Text('Change Password'),
                  subtitle: const Text('Update your account password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showChangePasswordDialog,
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 20),
                  ),
                  title: const Text('About'),
                  subtitle: const Text('App version & details'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'ETM Employee Web',
                      applicationVersion: '1.0.0+1',
                      applicationIcon: const Icon(Icons.directions_bus, size: 48, color: Color(0xFF2563EB)),
                      children: const [
                        Text('Employee Transport Management Web App'),
                        SizedBox(height: 8),
                        Text('Manage your daily commute, view rosters, and track trips.'),
                      ],
                    );
                  },
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.logout, color: Colors.red, size: 20),
                  ),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Sign out of your account'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final prefs = await ref.read(sharedPreferencesProvider.future);
                    await prefs.clear();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary, letterSpacing: 0.5)),
    );
  }
}
