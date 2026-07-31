import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../auth/auth_provider.dart';
import '../../settings/settings_screen.dart' as admin;
import '../../driver/settings/driver_settings_screen.dart';
import '../../employee/settings/employee_settings_screen.dart';

class SharedSettingsScreen extends ConsumerWidget {
  const SharedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final role = authState.user?.role;

    if (role == UserRole.driver) {
      return const DriverSettingsScreen();
    } else if (role == UserRole.employee) {
      return const EmployeeSettingsScreen();
    }
    return const admin.SettingsScreen();
  }
}
