import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';

final themeModeProvider = StateProvider<bool>((ref) => false);

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
            TextField(controller: currentPwController, decoration: const InputDecoration(labelText: 'Current Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 12),
            TextField(controller: newPwController, decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 12),
            TextField(controller: confirmPwController, decoration: const InputDecoration(labelText: 'Confirm New Password', border: OutlineInputBorder()), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
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
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;
    final horizontalPadding = isWide ? screenWidth * 0.15 : 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          children: [
            Center(
              child: CircleAvatar(
                radius: isWide ? 48 : 40,
                backgroundColor: const Color(0xFF2563EB),
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'E',
                  style: TextStyle(fontSize: isWide ? 36 : 32, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: Text(_userName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
            Center(child: Text(_userRole.toUpperCase(), style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500))),
            const SizedBox(height: 24),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                    title: const Text('Dark Mode'),
                    subtitle: Text(isDarkMode ? 'Dark theme active' : 'Light theme active'),
                    value: isDarkMode,
                    onChanged: (value) {
                      ref.read(themeModeProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset, color: Colors.orange),
                    title: const Text('Change Password'),
                    subtitle: const Text('Update your account password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showChangePasswordDialog,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: const Text('About'),
                    subtitle: const Text('App version & details'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'ETM Employee',
                        applicationVersion: '1.0.0+1',
                        applicationIcon: const Icon(Icons.directions_bus, size: 48, color: Color(0xFF2563EB)),
                        children: const [
                          Text('Employee Transport Management App'),
                          SizedBox(height: 8),
                          Text('Manage your daily commute, view rosters, and track trips.'),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
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
      ),
    );
  }
}
