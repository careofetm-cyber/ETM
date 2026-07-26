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
  String _userName = 'Driver';
  String _userEmail = '';
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    _userName = prefs.getString('user_name') ?? 'Driver';
    _userEmail = prefs.getString('user_email') ?? '';
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/auth/profile');
      _profile = resp.data;
    } catch (e) {
      debugPrint('Profile error: $e');
    }
    setState(() => _isLoading = false);
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully'), backgroundColor: Colors.green));
              } on DioException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.response?.data?['error'] ?? 'Failed to change password'), backgroundColor: Colors.red));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network error: $e'), backgroundColor: Colors.red));
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
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 16.0 : width < 900 ? 24.0 : 32.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: false),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadProfile,
                child: ListView(
                  padding: EdgeInsets.all(padding),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'D',
                        style: TextStyle(color: cs.onPrimaryContainer, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(child: Text(_userName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 4),
                  Center(child: Text('Driver', style: TextStyle(color: cs.onSurfaceVariant))),
                  const SizedBox(height: 24),

                  Card(
                    child: Column(
                      children: [
                        ListTile(leading: const Icon(Icons.email_outlined), title: Text(_userEmail), subtitle: const Text('Email')),
                        const Divider(height: 1),
                        ListTile(leading: const Icon(Icons.phone_outlined), title: Text(_profile?['phone'] ?? 'N/A'), subtitle: const Text('Phone')),
                        const Divider(height: 1),
                        ListTile(leading: const Icon(Icons.badge_outlined), title: Text(_profile?['license_number'] ?? 'N/A'), subtitle: const Text('License')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

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
          ),
    );
  }
}
