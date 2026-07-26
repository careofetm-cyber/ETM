import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final _superSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = await ref.watch(settingsApiProvider.future);
  return await api.getSettings();
});

class SuperSettingsScreen extends ConsumerStatefulWidget {
  const SuperSettingsScreen({super.key});

  @override
  ConsumerState<SuperSettingsScreen> createState() => _SuperSettingsScreenState();
}

class _SuperSettingsScreenState extends ConsumerState<SuperSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _initialized = false;

  // API Keys controllers
  final _mapApiKeyController = TextEditingController();
  final _firebaseProjectIdController = TextEditingController();
  final _firebaseApiKeyController = TextEditingController();
  final _smsGatewayUrlController = TextEditingController();
  final _smsGatewayTokenController = TextEditingController();
  final _smtpHostController = TextEditingController();
  final _smtpPortController = TextEditingController();
  final _smtpUsernameController = TextEditingController();
  final _smtpPasswordController = TextEditingController();
  final _smtpFromEmailController = TextEditingController();

  // Employee Defaults controllers
  final _idPrefixController = TextEditingController();
  final _idDigitCountController = TextEditingController();
  final _defaultPasswordFormatController = TextEditingController();
  final _defaultPasswordController = TextEditingController(text: 'password123');
  final _minPasswordLengthController = TextEditingController();
  bool _requireUppercase = true;
  bool _requireLowercase = true;
  bool _requireNumbers = true;
  bool _requireSpecialChars = true;

  // Visibility toggles
  bool _showMapApiKey = false;
  bool _showFirebaseApiKey = false;
  bool _showSmsToken = false;
  bool _showSmtpPassword = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapApiKeyController.dispose();
    _firebaseProjectIdController.dispose();
    _firebaseApiKeyController.dispose();
    _smsGatewayUrlController.dispose();
    _smsGatewayTokenController.dispose();
    _smtpHostController.dispose();
    _smtpPortController.dispose();
    _smtpUsernameController.dispose();
    _smtpPasswordController.dispose();
    _smtpFromEmailController.dispose();
    _idPrefixController.dispose();
    _idDigitCountController.dispose();
    _defaultPasswordFormatController.dispose();
    _minPasswordLengthController.dispose();
    super.dispose();
  }

  void _initControllers(Map<String, dynamic> settings) {
    if (_initialized) return;

    final apiKeys = settings['apiKeys'] as Map<String, dynamic>? ?? {};
    _mapApiKeyController.text = apiKeys['mapApiKey'] ?? '';
    _firebaseProjectIdController.text = (apiKeys['firebase'] as Map<String, dynamic>?)?['projectId'] ?? '';
    _firebaseApiKeyController.text = (apiKeys['firebase'] as Map<String, dynamic>?)?['apiKey'] ?? '';
    _smsGatewayUrlController.text = (apiKeys['sms'] as Map<String, dynamic>?)?['gatewayUrl'] ?? '';
    _smsGatewayTokenController.text = (apiKeys['sms'] as Map<String, dynamic>?)?['token'] ?? '';
    _smtpHostController.text = (apiKeys['smtp'] as Map<String, dynamic>?)?['host'] ?? '';
    _smtpPortController.text = (apiKeys['smtp'] as Map<String, dynamic>?)?['port'] ?? '';
    _smtpUsernameController.text = (apiKeys['smtp'] as Map<String, dynamic>?)?['username'] ?? '';
    _smtpPasswordController.text = (apiKeys['smtp'] as Map<String, dynamic>?)?['password'] ?? '';
    _smtpFromEmailController.text = (apiKeys['smtp'] as Map<String, dynamic>?)?['fromEmail'] ?? '';

    final employeeDefaults = settings['employeeDefaults'] as Map<String, dynamic>? ?? {};
    _idPrefixController.text = employeeDefaults['idPrefix'] ?? 'EMP';
    _idDigitCountController.text = (employeeDefaults['idDigitCount'] ?? 4).toString();
    _defaultPasswordController.text = employeeDefaults['defaultPassword'] ?? 'password123';
    _defaultPasswordFormatController.text = employeeDefaults['defaultPasswordFormat'] ?? 'auto';
    _minPasswordLengthController.text = (employeeDefaults['minPasswordLength'] ?? 8).toString();
    _requireUppercase = employeeDefaults['requireUppercase'] ?? true;
    _requireLowercase = employeeDefaults['requireLowercase'] ?? true;
    _requireNumbers = employeeDefaults['requireNumbers'] ?? true;
    _requireSpecialChars = employeeDefaults['requireSpecialChars'] ?? true;

    _initialized = true;
  }

  String get previewId {
    final prefix = _idPrefixController.text.isNotEmpty ? _idPrefixController.text : 'EMP';
    final digitCount = int.tryParse(_idDigitCountController.text) ?? 4;
    return '$prefix-${'0' * digitCount}1';
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(_superSettingsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Super Admin Settings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                settingsAsync.when(
                  data: (_) {
                    return ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveSettings,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Save'),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.vpn_key), text: 'API Keys'),
                Tab(icon: Icon(Icons.people), text: 'Employee Defaults'),
                Tab(icon: Icon(Icons.info_outline), text: 'System Info'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: settingsAsync.when(
                data: (settings) {
                  _initControllers(settings);
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildApiKeysTab(),
                      _buildEmployeeDefaultsTab(),
                      _buildSystemInfoTab(settings),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeysTab() {
    return Form(
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Map API Key', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mapApiKeyController,
                    obscureText: !_showMapApiKey,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter your map API key',
                      suffixIcon: IconButton(
                        icon: Icon(_showMapApiKey ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _showMapApiKey = !_showMapApiKey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Firebase Configuration', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firebaseProjectIdController,
                    decoration: const InputDecoration(
                      labelText: 'Project ID',
                      hintText: 'Enter Firebase project ID',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firebaseApiKeyController,
                    obscureText: !_showFirebaseApiKey,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter Firebase API key',
                      suffixIcon: IconButton(
                        icon: Icon(_showFirebaseApiKey ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _showFirebaseApiKey = !_showFirebaseApiKey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SMS Gateway', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _smsGatewayUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Gateway URL',
                      hintText: 'https://sms-gateway.example.com/api',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _smsGatewayTokenController,
                    obscureText: !_showSmsToken,
                    decoration: InputDecoration(
                      labelText: 'Token',
                      hintText: 'Enter SMS gateway token',
                      suffixIcon: IconButton(
                        icon: Icon(_showSmsToken ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _showSmsToken = !_showSmsToken),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email SMTP', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _smtpHostController,
                          decoration: const InputDecoration(
                            labelText: 'SMTP Host',
                            hintText: 'smtp.example.com',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _smtpPortController,
                          decoration: const InputDecoration(
                            labelText: 'Port',
                            hintText: '587',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _smtpUsernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter SMTP username',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _smtpPasswordController,
                    obscureText: !_showSmtpPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter SMTP password',
                      suffixIcon: IconButton(
                        icon: Icon(_showSmtpPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _showSmtpPassword = !_showSmtpPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _smtpFromEmailController,
                    decoration: const InputDecoration(
                      labelText: 'From Email',
                      hintText: 'noreply@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDefaultsTab() {
    return Form(
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Employee ID Format', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _idPrefixController,
                          decoration: const InputDecoration(
                            labelText: 'ID Prefix',
                            hintText: 'EMP',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _idDigitCountController,
                          decoration: const InputDecoration(
                            labelText: 'Digit Count',
                            hintText: '4',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.preview, size: 20),
                        const SizedBox(width: 12),
                        Text('Preview: ', style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          previewId,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Default Password Settings', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _defaultPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Default Password for New Users',
                      hintText: 'password123',
                      helperText: 'Used when creating new employees and drivers',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _defaultPasswordFormatController,
                    decoration: const InputDecoration(
                      labelText: 'Password Format',
                      hintText: 'auto or custom format string',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _minPasswordLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Length',
                      hintText: '8',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password Requirements', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Require Uppercase Letters'),
                    subtitle: const Text('A-Z'),
                    value: _requireUppercase,
                    onChanged: (v) => setState(() => _requireUppercase = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: const Text('Require Lowercase Letters'),
                    subtitle: const Text('a-z'),
                    value: _requireLowercase,
                    onChanged: (v) => setState(() => _requireLowercase = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: const Text('Require Numbers'),
                    subtitle: const Text('0-9'),
                    value: _requireNumbers,
                    onChanged: (v) => setState(() => _requireNumbers = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: const Text('Require Special Characters'),
                    subtitle: const Text('!@#\$%^&*'),
                    value: _requireSpecialChars,
                    onChanged: (v) => setState(() => _requireSpecialChars = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoTab(Map<String, dynamic> settings) {
    final systemInfo = settings['systemInfo'] as Map<String, dynamic>? ?? {};
    final dbStats = settings['databaseStats'] as Map<String, dynamic>? ?? {};

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('System Version', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _infoTile('Version', systemInfo['version'] ?? '1.0.0'),
                _infoTile('Build', systemInfo['build'] ?? '1'),
                _infoTile('Environment', systemInfo['environment'] ?? 'production'),
                _infoTile('Last Updated', systemInfo['lastUpdated'] ?? 'N/A'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Database Statistics', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _infoTile('Total Employees', dbStats['totalEmployees']?.toString() ?? '0'),
                _infoTile('Total Drivers', dbStats['totalDrivers']?.toString() ?? '0'),
                _infoTile('Total Vehicles', dbStats['totalVehicles']?.toString() ?? '0'),
                _infoTile('Total Trips', dbStats['totalTrips']?.toString() ?? '0'),
                _infoTile('Total Companies', dbStats['totalCompanies']?.toString() ?? '0'),
                _infoTile('Database Size', dbStats['databaseSize'] ?? 'N/A'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      final api = await ref.read(settingsApiProvider.future);
      await api.updateSettings({
        'apiKeys': {
          'mapApiKey': _mapApiKeyController.text,
          'firebase': {
            'projectId': _firebaseProjectIdController.text,
            'apiKey': _firebaseApiKeyController.text,
          },
          'sms': {
            'gatewayUrl': _smsGatewayUrlController.text,
            'token': _smsGatewayTokenController.text,
          },
          'smtp': {
            'host': _smtpHostController.text,
            'port': _smtpPortController.text,
            'username': _smtpUsernameController.text,
            'password': _smtpPasswordController.text,
            'fromEmail': _smtpFromEmailController.text,
          },
        },
        'employeeDefaults': {
          'idPrefix': _idPrefixController.text,
          'idDigitCount': int.tryParse(_idDigitCountController.text) ?? 4,
          'defaultPassword': _defaultPasswordController.text,
          'defaultPasswordFormat': _defaultPasswordFormatController.text,
          'minPasswordLength': int.tryParse(_minPasswordLengthController.text) ?? 8,
          'requireUppercase': _requireUppercase,
          'requireLowercase': _requireLowercase,
          'requireNumbers': _requireNumbers,
          'requireSpecialChars': _requireSpecialChars,
        },
      });
      ref.invalidate(_superSettingsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
