import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userRole = '';
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    _userName = prefs.getString('user_name') ?? 'Employee';
    _userEmail = prefs.getString('user_email') ?? '';
    _userRole = prefs.getString('user_role') ?? 'employee';
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/auth/profile');
      _profile = resp.data;
    } catch (e) {
      debugPrint('Profile error: $e');
    }
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed'), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
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
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF2563EB),
              child: Text(_userName.isNotEmpty ? _userName[0].toUpperCase() : 'E', style: const TextStyle(fontSize: 32, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text(_userName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
          Center(child: Text(_userEmail, style: const TextStyle(color: Colors.grey))),
          Center(child: Text(_userRole.toUpperCase(), style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500))),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.phone), title: Text(_profile?['phone'] ?? '+91 98765 43210'), subtitle: const Text('Phone')),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.business), title: Text(_profile?['department'] ?? 'Engineering'), subtitle: const Text('Department')),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.work), title: Text(_profile?['designation'] ?? 'Employee'), subtitle: const Text('Designation')),
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
