import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../shared/providers/api_providers.dart';

final userManagementSearchProvider = StateProvider<String>((ref) => '');
final userManagementRoleFilterProvider = StateProvider<String>((ref) => '');

final usersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = await ref.watch(userManagementApiProvider.future);
  return api.getUsers();
});

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController(text: 'password123');
  final _departmentController = TextEditingController();
  final _designationController = TextEditingController();
  final _employeeCodeController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _licenseExpiryController = TextEditingController();

  String _selectedRole = 'employee';

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _employeeCodeController.dispose();
    _licenseNumberController.dispose();
    _licenseExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'User Management',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddUserDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      ref.read(userManagementSearchProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Role',
                    ),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('All Roles')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'manager', child: Text('Manager')),
                      DropdownMenuItem(value: 'employee', child: Text('Employee')),
                      DropdownMenuItem(value: 'driver', child: Text('Driver')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value ?? '';
                      });
                      ref.read(userManagementRoleFilterProvider.notifier).state = value ?? '';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: usersAsync.when(
                    data: (users) {
                      final search = ref.watch(userManagementSearchProvider);
                      final roleFilter = ref.watch(userManagementRoleFilterProvider);

                      var filteredUsers = users.where((user) {
                        final name = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.toLowerCase();
                        final email = (user['email'] ?? '').toLowerCase();
                        final matchesSearch = search.isEmpty ||
                            name.contains(search.toLowerCase()) ||
                            email.contains(search.toLowerCase());
                        final matchesRole = roleFilter.isEmpty || user['role'] == roleFilter;
                        return matchesSearch && matchesRole;
                      }).toList();

                      if (filteredUsers.isEmpty) {
                        return const Center(child: Text('No users found'));
                      }
                      return _buildUsersTable(filteredUsers);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'manager':
        return Colors.blue;
      case 'employee':
        return Colors.green;
      case 'driver':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildUsersTable(List<Map<String, dynamic>> users) {
    return Column(
      children: [
        Expanded(
          child: DataTable2(
            columns: const [
              DataColumn2(label: Text('Name'), size: ColumnSize.L),
              DataColumn2(label: Text('Email')),
              DataColumn2(label: Text('Phone')),
              DataColumn2(label: Text('Role')),
              DataColumn2(label: Text('Status')),
              DataColumn2(label: Text('Actions'), size: ColumnSize.S),
            ],
            rows: users.map((user) {
              final fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}';
              final role = user['role'] ?? 'employee';
              final isActive = user['isActive'] ?? true;

              return DataRow2(cells: [
                DataCell(Text(fullName.trim().isEmpty ? '-' : fullName.trim())),
                DataCell(Text(user['email'] ?? '-')),
                DataCell(Text(user['phone'] ?? '-')),
                DataCell(
                  Chip(
                    label: Text(
                      role.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: _getRoleColor(role),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                DataCell(
                  Icon(
                    isActive ? Icons.check_circle : Icons.cancel,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditUserDialog(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.lock_reset, size: 20, color: Colors.orange),
                      tooltip: 'Reset Password',
                      onPressed: () => _showResetPasswordDialog(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _showDeactivateConfirmation(context, user),
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _clearControllers() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.text = 'password123';
    _departmentController.clear();
    _designationController.clear();
    _employeeCodeController.clear();
    _licenseNumberController.clear();
    _licenseExpiryController.clear();
    _selectedRole = 'employee';
  }

  void _showAddUserDialog(BuildContext context) {
    _clearControllers();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add User'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Role *'),
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'manager', child: Text('Manager')),
                        DropdownMenuItem(value: 'employee', child: Text('Employee')),
                        DropdownMenuItem(value: 'driver', child: Text('Driver')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedRole = value ?? 'employee';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name *'),
                      validator: (v) => v == null || v.isEmpty ? 'First name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name *'),
                      validator: (v) => v == null || v.isEmpty ? 'Last name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email *'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(labelText: 'Password'),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            _passwordController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _passwordController.text.length,
                            );
                          },
                          tooltip: 'Copy password',
                        ),
                      ],
                    ),
                    if (_selectedRole == 'employee') ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Employee Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _departmentController,
                        decoration: const InputDecoration(labelText: 'Department *'),
                        validator: (v) => _selectedRole == 'employee' && (v == null || v.isEmpty) ? 'Department is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _designationController,
                        decoration: const InputDecoration(labelText: 'Designation'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _employeeCodeController,
                        decoration: const InputDecoration(labelText: 'Employee Code'),
                      ),
                    ],
                    if (_selectedRole == 'driver') ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Driver Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _licenseNumberController,
                        decoration: const InputDecoration(labelText: 'License Number'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _licenseExpiryController,
                        decoration: const InputDecoration(labelText: 'License Expiry'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final api = await ref.read(userManagementApiProvider.future);
                  final data = {
                    'firstName': _firstNameController.text,
                    'lastName': _lastNameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'password': _passwordController.text,
                    'role': _selectedRole,
                  };

                  if (_selectedRole == 'employee') {
                    data['department'] = _departmentController.text;
                    data['designation'] = _designationController.text;
                    data['employeeCode'] = _employeeCodeController.text;
                  }

                  if (_selectedRole == 'driver') {
                    data['licenseNumber'] = _licenseNumberController.text;
                    data['licenseExpiry'] = _licenseExpiryController.text;
                  }

                  await api.createUser(data);
                  if (context.mounted) Navigator.pop(context);
                  ref.invalidate(usersProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User created successfully'), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create user: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
    _firstNameController.text = user['firstName'] ?? '';
    _lastNameController.text = user['lastName'] ?? '';
    _emailController.text = user['email'] ?? '';
    _phoneController.text = user['phone'] ?? '';
    _passwordController.clear();
    _departmentController.text = user['department'] ?? '';
    _designationController.text = user['designation'] ?? '';
    _employeeCodeController.text = user['employeeCode'] ?? '';
    _licenseNumberController.text = user['licenseNumber'] ?? '';
    _licenseExpiryController.text = user['licenseExpiry'] ?? '';
    _selectedRole = user['role'] ?? 'employee';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit User'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Role *'),
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'manager', child: Text('Manager')),
                        DropdownMenuItem(value: 'employee', child: Text('Employee')),
                        DropdownMenuItem(value: 'driver', child: Text('Driver')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedRole = value ?? 'employee';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name *'),
                      validator: (v) => v == null || v.isEmpty ? 'First name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name *'),
                      validator: (v) => v == null || v.isEmpty ? 'Last name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email *'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    if (_selectedRole == 'employee') ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Employee Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _departmentController,
                        decoration: const InputDecoration(labelText: 'Department *'),
                        validator: (v) => _selectedRole == 'employee' && (v == null || v.isEmpty) ? 'Department is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _designationController,
                        decoration: const InputDecoration(labelText: 'Designation'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _employeeCodeController,
                        decoration: const InputDecoration(labelText: 'Employee Code'),
                      ),
                    ],
                    if (_selectedRole == 'driver') ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Driver Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _licenseNumberController,
                        decoration: const InputDecoration(labelText: 'License Number'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _licenseExpiryController,
                        decoration: const InputDecoration(labelText: 'License Expiry'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final api = await ref.read(userManagementApiProvider.future);
                  final data = {
                    'firstName': _firstNameController.text,
                    'lastName': _lastNameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'role': _selectedRole,
                  };

                  if (_passwordController.text.isNotEmpty) {
                    data['password'] = _passwordController.text;
                  }

                  if (_selectedRole == 'employee') {
                    data['department'] = _departmentController.text;
                    data['designation'] = _designationController.text;
                    data['employeeCode'] = _employeeCodeController.text;
                  }

                  if (_selectedRole == 'driver') {
                    data['licenseNumber'] = _licenseNumberController.text;
                    data['licenseExpiry'] = _licenseExpiryController.text;
                  }

                  await api.updateUser(user['id'].toString(), data);
                  if (context.mounted) Navigator.pop(context);
                  ref.invalidate(usersProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User updated successfully'), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update user: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateConfirmation(BuildContext context, Map<String, dynamic> user) {
    final fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate User'),
        content: Text('Are you sure you want to deactivate $fullName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                final api = await ref.read(userManagementApiProvider.future);
                await api.deleteUser(user['id'].toString());
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(usersProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deactivated'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to deactivate user: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, Map<String, dynamic> user) {
    final fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}';
    final passwordController = TextEditingController(text: 'password123');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset password for $fullName'),
            Text('Email: ${user['email']}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text('User will be notified and required to change password on next login.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              try {
                final dio = ref.read(dioProvider);
                await dio.post('/users/${user['id']}/reset-password', data: {
                  'newPassword': passwordController.text,
                });
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password reset to: ${passwordController.text}'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to reset password: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }
}
