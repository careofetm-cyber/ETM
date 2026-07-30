import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  void _showUpdateHomeLocationDialog() {
    final addressController = TextEditingController(text: _profile?['homeAddress'] ?? '');
    final latController = TextEditingController(text: (_profile?['homeLatitude'] ?? '').toString());
    final lngController = TextEditingController(text: (_profile?['homeLongitude'] ?? '').toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Home Location'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Home Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.home)), maxLines: 2),
              const SizedBox(height: 12),
              TextField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on)), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true)),
              const SizedBox(height: 12),
              TextField(controller: lngController, decoration: const InputDecoration(labelText: 'Longitude', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on)), keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () async {
              final prefs = await ref.read(sharedPreferencesProvider.future);
              final userId = prefs.getString('user_id');
              if (userId == null) return;
              try {
                final dio = ref.read(dioProvider);
                await dio.put('/employees/user/$userId/location', data: {
                  'homeAddress': addressController.text.trim(),
                  'homeLatitude': double.tryParse(latController.text.trim()) ?? 0,
                  'homeLongitude': double.tryParse(lngController.text.trim()) ?? 0,
                });
                Navigator.pop(ctx);
                await _loadProfile();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Home location updated'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update location: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Update'),
          ),
        ],
      ),
    );
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed'), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 800;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(isWide ? 24 : 16),
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
            child: isWide
                ? Row(
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
                              child: Text(_userRole.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: _userName.isNotEmpty
                            ? Text(_userName[0].toUpperCase(), style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))
                            : const Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(_userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(_userEmail, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: Text(_userRole.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _buildInfoTile(Icons.phone, 'Phone', _profile?['phone'] ?? '+91 98765 43210'),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(Icons.business, 'Department', _profile?['department'] ?? 'Engineering'),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(Icons.work, 'Designation', _profile?['designation'] ?? 'Employee'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Home Location'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF059669).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.home, color: Color(0xFF059669), size: 20),
                  ),
                  title: const Text('Home / Pickup Location'),
                  subtitle: Text(_profile?['homeAddress'] ?? 'Not set', style: TextStyle(color: _profile?['homeAddress'] != null ? null : Colors.grey)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showUpdateHomeLocationDialog,
                ),
                if (_profile?['homeAddress'] != null) ...[
                  const Divider(height: 1, indent: 56),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                        Text('${_profile?['homeLatitude'] ?? 0}, ${_profile?['homeLongitude'] ?? 0}', style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary, letterSpacing: 0.5)),
    );
  }
}
