import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final _companyProvider = FutureProvider<Company?>((ref) async {
  try {
    final api = await ref.watch(companyApiProvider.future);
    return await api.getCompany('current');
  } catch (e) {
    return null;
  }
});

final _companySettingsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final dio = ref.read(dioProvider);
    final resp = await dio.get('/settings/company');
    return resp.data;
  } catch (e) {
    return null;
  }
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _logoController = TextEditingController();
  final _bgImageController = TextEditingController();
  final _faviconController = TextEditingController();
  final _tripCostController = TextEditingController();
  final _minKmController = TextEditingController();
  bool _isLoading = false;
  bool _initialized = false;
  bool _homeLocationEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _logoController.dispose();
    _bgImageController.dispose();
    _faviconController.dispose();
    _tripCostController.dispose();
    _minKmController.dispose();
    super.dispose();
  }

  void _initControllers(Company company) {
    if (_initialized) return;
    _nameController.text = company.name;
    _emailController.text = company.email ?? '';
    _phoneController.text = company.phone ?? '';
    _addressController.text = company.address ?? '';
    _cityController.text = company.city ?? '';
    _stateController.text = company.state ?? '';
    _logoController.text = company.logo ?? '';
    _tripCostController.text = (company.tripCostPerTrip ?? 0).toString();
    _minKmController.text = (company.minimumKmForBilling ?? 0).toString();
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final companyAsync = ref.watch(_companyProvider);
    final settingsAsync = ref.watch(_companySettingsProvider);

    settingsAsync.whenData((settings) {
      if (settings != null && !_initialized) {
        _homeLocationEnabled = settings['homeLocationEnabled'] ?? settings['home_location_enabled'] ?? true;
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                companyAsync.when(
                  data: (company) {
                    if (company != null) {
                      return ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _saveCompany(context),
                        icon: _isLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.save),
                        label: const Text('Save'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: companyAsync.when(
                data: (company) {
                  if (company == null) {
                    return const Center(child: Text('Could not load company data'));
                  }
                  _initControllers(company);
                  return _buildForm(company);
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

  Widget _buildForm(Company company) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business_outlined, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Company Profile', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name *',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Company name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            prefixIcon: Icon(Icons.location_city_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(
                            labelText: 'State',
                            prefixIcon: Icon(Icons.map_outlined),
                          ),
                        ),
                      ),
                    ],
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
                  Row(
                    children: [
                      Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Branding', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _logoController,
                    decoration: const InputDecoration(
                      labelText: 'Logo URL',
                      hintText: 'https://example.com/logo.png',
                      prefixIcon: Icon(Icons.image_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bgImageController,
                    decoration: const InputDecoration(
                      labelText: 'Background Image URL',
                      hintText: 'https://example.com/bg.jpg',
                      prefixIcon: Icon(Icons.photo_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _faviconController,
                    decoration: const InputDecoration(
                      labelText: 'Favicon URL',
                      hintText: 'https://example.com/favicon.ico',
                      prefixIcon: Icon(Icons.tab_outlined),
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
                  Row(
                    children: [
                      Icon(Icons.attach_money_rounded, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Billing Settings', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tripCostController,
                          decoration: const InputDecoration(
                            labelText: 'Trip Cost Per Trip (\$)',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            if (double.tryParse(v) == null) return 'Must be a number';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _minKmController,
                          decoration: const InputDecoration(
                            labelText: 'Minimum KM for Billing',
                            prefixIcon: Icon(Icons.straighten),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            if (double.tryParse(v) == null) return 'Must be a number';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.link, size: 20),
                    title: const Text('Company URL Slug'),
                    subtitle: Text(company.name.toLowerCase().replaceAll(' ', '-')),
                    trailing: const Icon(Icons.copy),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Slug copied to clipboard'), backgroundColor: AppColors.success),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.card_membership, size: 20),
                    title: const Text('Plan'),
                    subtitle: Text((company.plan ?? 'basic')[0].toUpperCase() + (company.plan ?? 'basic').substring(1)),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.verified_outlined, size: 20),
                    title: const Text('Subscription Status'),
                    subtitle: Text((company.subscriptionStatus ?? 'active')[0].toUpperCase() + (company.subscriptionStatus ?? 'active').substring(1)),
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
                  Row(
                    children: [
                      Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Transport Settings', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Allow Employee Home Location Update'),
                    subtitle: const Text('When enabled, employees can set/update their home pickup location from the app'),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _homeLocationEnabled ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.home_outlined,
                        color: _homeLocationEnabled ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                    ),
                    value: _homeLocationEnabled,
                    onChanged: (value) {
                      setState(() => _homeLocationEnabled = value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCompany(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final api = await ref.read(companyApiProvider.future);
      await api.updateCompany('current', {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'logo': _logoController.text,
        'tripCostPerTrip': double.tryParse(_tripCostController.text) ?? 0,
        'minimumKmForBilling': double.tryParse(_minKmController.text) ?? 0,
      });

      try {
        final dio = ref.read(dioProvider);
        await dio.put('/settings/company', data: {
          'homeLocationEnabled': _homeLocationEnabled,
        });
      } catch (_) {}

      ref.invalidate(_companyProvider);
      ref.invalidate(_companySettingsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
