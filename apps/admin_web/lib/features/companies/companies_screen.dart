import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final companiesFilterPlanProvider = StateProvider<String>((ref) => 'all');
final companiesFilterStatusProvider = StateProvider<String>((ref) => 'all');
final companiesSearchProvider = StateProvider<String>((ref) => '');

final companiesProvider = FutureProvider<List<Company>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  final plan = ref.watch(companiesFilterPlanProvider);
  final status = ref.watch(companiesFilterStatusProvider);
  return api.getCompanies(
    plan: plan == 'all' ? null : plan,
    status: status == 'all' ? null : status,
  );
});

class CompaniesScreen extends ConsumerStatefulWidget {
  const CompaniesScreen({super.key});

  @override
  ConsumerState<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends ConsumerState<CompaniesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Companies',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddCompanyDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Company'),
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
                      hintText: 'Search companies...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      ref.read(companiesSearchProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: ref.watch(companiesFilterPlanProvider),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Plans')),
                    DropdownMenuItem(value: 'basic', child: Text('Basic')),
                    DropdownMenuItem(value: 'standard', child: Text('Standard')),
                    DropdownMenuItem(value: 'premium', child: Text('Premium')),
                  ],
                  onChanged: (value) {
                    ref.read(companiesFilterPlanProvider.notifier).state = value!;
                    ref.invalidate(companiesProvider);
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: ref.watch(companiesFilterStatusProvider),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                    DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                  ],
                  onChanged: (value) {
                    ref.read(companiesFilterStatusProvider.notifier).state = value!;
                    ref.invalidate(companiesProvider);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: companiesAsync.when(
                    data: (companies) {
                      final query = ref.read(companiesSearchProvider).toLowerCase();
                      final filtered = query.isEmpty
                          ? companies
                          : companies.where((c) =>
                              c.name.toLowerCase().contains(query) ||
                              (c.email?.toLowerCase().contains(query) ?? false) ||
                              (c.city?.toLowerCase().contains(query) ?? false)).toList();
                      if (filtered.isEmpty) {
                        return const Center(child: Text('No companies found'));
                      }
                      return _buildCompaniesTable(filtered);
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

  Widget _buildCompaniesTable(List<Company> companies) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Company'), size: ColumnSize.L),
        DataColumn2(label: Text('Plan')),
        DataColumn2(label: Text('Status')),
        DataColumn2(label: Text('Trip Cost')),
        DataColumn2(label: Text('Min KM')),
        DataColumn2(label: Text('Monthly Limit')),
        DataColumn2(label: Text('Trips Used')),
        DataColumn2(label: Text('Actions'), size: ColumnSize.S),
      ],
      rows: companies.map((company) {
        return DataRow2(cells: [
          DataCell(Text(company.name)),
          DataCell(_buildPlanChip(company.plan ?? 'basic')),
          DataCell(_buildStatusChip(company.subscriptionStatus ?? 'active')),
          DataCell(Text('\$${(company.tripCostPerTrip ?? 0).toStringAsFixed(2)}')),
          DataCell(Text('${company.minimumKmForBilling ?? 0}')),
          DataCell(Text('${company.monthlyTripLimit ?? 0}')),
          DataCell(Text('${company.tripsUsedThisMonth ?? 0}')),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 20),
                onPressed: () => _showCompanyDetail(context, company),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _showEditCompanyDialog(context, company),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                onPressed: () => _showDeleteConfirmation(context, company),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildPlanChip(String plan) {
    Color color;
    switch (plan) {
      case 'premium':
        color = AppColors.accent;
        break;
      case 'standard':
        color = AppColors.info;
        break;
      default:
        color = AppColors.textSecondary;
    }
    return Chip(
      label: Text(plan[0].toUpperCase() + plan.substring(1)),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'active':
        color = AppColors.success;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        break;
      case 'suspended':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }
    return Chip(
      label: Text(status[0].toUpperCase() + status.substring(1)),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  void _showCompanyDetail(BuildContext context, Company company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(company.name),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Email', company.email ?? '-'),
              _detailRow('Phone', company.phone ?? '-'),
              _detailRow('Address', company.address ?? '-'),
              _detailRow('City', company.city ?? '-'),
              _detailRow('State', company.state ?? '-'),
              const Divider(),
              _detailRow('Plan', company.plan ?? 'basic'),
              _detailRow('Trip Cost', '\$${(company.tripCostPerTrip ?? 0).toStringAsFixed(2)}'),
              _detailRow('Min KM', '${company.minimumKmForBilling ?? 0}'),
              _detailRow('Monthly Limit', '${company.monthlyTripLimit ?? 0}'),
              _detailRow('Trips Used', '${company.tripsUsedThisMonth ?? 0}'),
              _detailRow('Status', company.subscriptionStatus ?? 'active'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddCompanyDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final tripCostController = TextEditingController(text: '0');
    final minKmController = TextEditingController(text: '0');
    final monthlyLimitController = TextEditingController(text: '0');
    final adminEmailController = TextEditingController();
    final adminPasswordController = TextEditingController(text: 'admin123');
    String selectedPlan = 'basic';
    String selectedStatus = 'active';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Company'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Company Name *'), validator: (v) => v == null || v.isEmpty ? 'Name is required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                    const SizedBox(height: 12),
                    TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City'))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State'))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedPlan,
                      decoration: const InputDecoration(labelText: 'Plan'),
                      items: const [
                        DropdownMenuItem(value: 'basic', child: Text('Basic')),
                        DropdownMenuItem(value: 'standard', child: Text('Standard')),
                        DropdownMenuItem(value: 'premium', child: Text('Premium')),
                      ],
                      onChanged: (v) => setDialogState(() => selectedPlan = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Subscription Status'),
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                        DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                      ],
                      onChanged: (v) => setDialogState(() => selectedStatus = v!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(controller: tripCostController, decoration: const InputDecoration(labelText: 'Trip Cost Per Trip'), keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (double.tryParse(v) == null) return 'Must be a number';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextFormField(controller: minKmController, decoration: const InputDecoration(labelText: 'Minimum KM for Billing'), keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (double.tryParse(v) == null) return 'Must be a number';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextFormField(controller: monthlyLimitController, decoration: const InputDecoration(labelText: 'Monthly Trip Limit'), keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (int.tryParse(v) == null) return 'Must be a number';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextFormField(controller: adminEmailController, decoration: const InputDecoration(labelText: 'Admin Email *'), keyboardType: TextInputType.emailAddress, validator: (v) => v == null || v.isEmpty ? 'Admin email is required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: adminPasswordController, decoration: const InputDecoration(labelText: 'Admin Password'), obscureText: true),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final api = await ref.read(superAdminApiProvider.future);
                  await api.createCompany({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                    'city': cityController.text,
                    'state': stateController.text,
                    'plan': selectedPlan,
                    'subscriptionStatus': selectedStatus,
                    'tripCostPerTrip': double.tryParse(tripCostController.text) ?? 0,
                    'minimumKmForBilling': double.tryParse(minKmController.text) ?? 0,
                    'monthlyTripLimit': int.tryParse(monthlyLimitController.text) ?? 0,
                    'adminEmail': adminEmailController.text,
                    'adminPassword': adminPasswordController.text.isEmpty ? 'admin123' : adminPasswordController.text,
                  });
                  if (context.mounted) Navigator.pop(context);
                  ref.invalidate(companiesProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Company added successfully'), backgroundColor: AppColors.success),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add company: $e'), backgroundColor: AppColors.error),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCompanyDialog(BuildContext context, Company company) {
    final nameController = TextEditingController(text: company.name);
    final emailController = TextEditingController(text: company.email ?? '');
    final phoneController = TextEditingController(text: company.phone ?? '');
    final addressController = TextEditingController(text: company.address ?? '');
    final cityController = TextEditingController(text: company.city ?? '');
    final stateController = TextEditingController(text: company.state ?? '');
    final tripCostController = TextEditingController(text: (company.tripCostPerTrip ?? 0).toString());
    final minKmController = TextEditingController(text: (company.minimumKmForBilling ?? 0).toString());
    final monthlyLimitController = TextEditingController(text: (company.monthlyTripLimit ?? 0).toString());
    String selectedPlan = company.plan ?? 'basic';
    String selectedStatus = company.subscriptionStatus ?? 'active';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Company'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Company Name *'), validator: (v) => v == null || v.isEmpty ? 'Name is required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                    const SizedBox(height: 12),
                    TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City'))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State'))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedPlan,
                      decoration: const InputDecoration(labelText: 'Plan'),
                      items: const [
                        DropdownMenuItem(value: 'basic', child: Text('Basic')),
                        DropdownMenuItem(value: 'standard', child: Text('Standard')),
                        DropdownMenuItem(value: 'premium', child: Text('Premium')),
                      ],
                      onChanged: (v) => setDialogState(() => selectedPlan = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Subscription Status'),
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                        DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                      ],
                      onChanged: (v) => setDialogState(() => selectedStatus = v!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(controller: tripCostController, decoration: const InputDecoration(labelText: 'Trip Cost Per Trip'), keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (double.tryParse(v) == null) return 'Must be a number';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextFormField(controller: minKmController, decoration: const InputDecoration(labelText: 'Minimum KM for Billing'), keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (double.tryParse(v) == null) return 'Must be a number';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    TextFormField(controller: monthlyLimitController, decoration: const InputDecoration(labelText: 'Monthly Trip Limit'), keyboardType: TextInputType.number, validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (int.tryParse(v) == null) return 'Must be a number';
                      return null;
                    }),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final api = await ref.read(superAdminApiProvider.future);
                  await api.updateCompany(company.id, {
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                    'city': cityController.text,
                    'state': stateController.text,
                    'plan': selectedPlan,
                    'subscriptionStatus': selectedStatus,
                    'tripCostPerTrip': double.tryParse(tripCostController.text) ?? 0,
                    'minimumKmForBilling': double.tryParse(minKmController.text) ?? 0,
                    'monthlyTripLimit': int.tryParse(monthlyLimitController.text) ?? 0,
                  });
                  if (context.mounted) Navigator.pop(context);
                  ref.invalidate(companiesProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Company updated successfully'), backgroundColor: AppColors.success),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update company: $e'), backgroundColor: AppColors.error),
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

  void _showDeleteConfirmation(BuildContext context, Company company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Company'),
        content: Text('Are you sure you want to delete ${company.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              try {
                final api = await ref.read(superAdminApiProvider.future);
                await api.deleteCompany(company.id);
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(companiesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Company deleted'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete company: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
