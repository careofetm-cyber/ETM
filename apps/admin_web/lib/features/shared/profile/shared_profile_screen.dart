import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/api_providers.dart';
import '../../auth/auth_provider.dart';

class SharedProfileScreen extends ConsumerStatefulWidget {
  const SharedProfileScreen({super.key});
  @override
  ConsumerState<SharedProfileScreen> createState() => _SharedProfileScreenState();
}

class _SharedProfileScreenState extends ConsumerState<SharedProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userRole = '';
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    _userName = prefs.getString('user_name') ?? 'User';
    _userEmail = prefs.getString('user_email') ?? '';
    _userRole = prefs.getString('user_role') ?? '';
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/auth/profile');
      _profile = resp.data;
    } catch (e) {
      debugPrint('Profile error: $e');
    }
    setState(() => _isLoading = false);
  }

  String _roleDisplayName(String role) {
    switch (role) {
      case 'super_admin': return 'Super Admin';
      case 'admin': return 'Admin';
      case 'transport_manager': return 'Transport Manager';
      case 'hr': return 'HR';
      case 'manager': return 'Manager';
      case 'employee': return 'Employee';
      case 'driver': return 'Driver';
      default: return 'User';
    }
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
    final cs = Theme.of(context).colorScheme;

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(32),
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
                radius: 48,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: _userName.isNotEmpty
                    ? Text(_userName[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold))
                    : const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(_userEmail, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text(_roleDisplayName(_userRole), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              _buildInfoTile(Icons.email, 'Email', _userEmail.isNotEmpty ? _userEmail : 'N/A'),
              if (_profile?['phone'] != null) ...[
                const Divider(height: 1, indent: 56),
                _buildInfoTile(Icons.phone, 'Phone', _profile!['phone']),
              ],
              if (_profile?['department'] != null) ...[
                const Divider(height: 1, indent: 56),
                _buildInfoTile(Icons.business, 'Department', _profile!['department']),
              ],
              if (_profile?['designation'] != null) ...[
                const Divider(height: 1, indent: 56),
                _buildInfoTile(Icons.work, 'Designation', _profile!['designation']),
              ],
              if (_profile?['license_number'] != null) ...[
                const Divider(height: 1, indent: 56),
                _buildInfoTile(Icons.badge, 'License', _profile!['license_number']),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
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
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.logout, color: Colors.red, size: 20),
                ),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                subtitle: const Text('Sign out of your account'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
