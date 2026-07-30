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
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: currentPwController,
                  decoration: const InputDecoration(
                      labelText: 'Current Password', border: OutlineInputBorder()),
                  obscureText: true),
              const SizedBox(height: 12),
              TextField(
                  controller: newPwController,
                  decoration: const InputDecoration(
                      labelText: 'New Password', border: OutlineInputBorder()),
                  obscureText: true),
              const SizedBox(height: 12),
              TextField(
                  controller: confirmPwController,
                  decoration: const InputDecoration(
                      labelText: 'Confirm New Password', border: OutlineInputBorder()),
                  obscureText: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (newPwController.text != confirmPwController.text) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                return;
              }
              try {
                final dio = ref.read(dioProvider);
                await dio.put('/auth/change-password', data: {
                  'currentPassword': currentPwController.text,
                  'newPassword': newPwController.text,
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully'), backgroundColor: Colors.green));
              } on DioException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.response?.data?['error'] ?? 'Failed to change password'),
                    backgroundColor: Colors.red));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Network error: $e'), backgroundColor: Colors.red));
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
    final useWideLayout = width > 700;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadProfile,
            child: useWideLayout
                ? _buildWideLayout(cs, padding)
                : _buildNarrowLayout(cs, padding),
          );
  }

  Widget _buildWideLayout(ColorScheme cs, double padding) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              _buildProfileHeader(cs),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
              _buildAccountInfo(cs),
              const SizedBox(height: 16),
              _buildActions(cs),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(ColorScheme cs, double padding) {
    return ListView(
      padding: EdgeInsets.all(padding),
      children: [
        _buildProfileHeader(cs),
        const SizedBox(height: 20),
        _buildAccountInfo(cs),
        const SizedBox(height: 16),
        _buildActions(cs),
      ],
    );
  }

  Widget _buildProfileHeader(ColorScheme cs) {
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
            radius: 44,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'D',
              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 14),
          Text(_userName,
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_userEmail,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                const Text('Driver', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account Info',
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
                  child: Icon(Icons.email_outlined, color: cs.onPrimaryContainer, size: 20),
                ),
                title: Text(_userEmail, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Email'),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.phone_outlined, color: Colors.teal.shade700, size: 20),
                ),
                title: Text(_profile?['phone'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Phone'),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.badge_outlined, color: Colors.orange.shade700, size: 20),
                ),
                title: Text(_profile?['license_number'] ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('License'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions',
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
                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.lock_reset, color: Colors.orange.shade700, size: 20),
                ),
                title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Update your account password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showChangePasswordDialog,
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.logout, color: Colors.red.shade600, size: 20),
                ),
                title:
                    Text('Logout', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w500)),
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
    );
  }
}
