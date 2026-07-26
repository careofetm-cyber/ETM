import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';
part 'dashboard.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int totalVehicles,
    required int activeVehicles,
    required int totalDrivers,
    required int activeDrivers,
    required int totalEmployees,
    required int activeTrips,
    required int completedTripsToday,
    required int pendingRequests,
    required int totalRoutes,
    int? alertsCount,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}

@freezed
class DriverDashboard with _$DriverDashboard {
  const factory DriverDashboard({
    required int todayTrips,
    required int completedTrips,
    required int pendingTrips,
    required double totalDistance,
    required int totalPassengers,
    String? assignedVehicle,
    String? currentTripId,
  }) = _DriverDashboard;

  factory DriverDashboard.fromJson(Map<String, dynamic> json) => _$DriverDashboardFromJson(json);
}

@freezed
class EmployeeDashboard with _$EmployeeDashboard {
  const factory EmployeeDashboard({
    required bool hasUpcomingTrip,
    String? nextTripId,
    DateTime? nextTripTime,
    String? nextTripRoute,
    String? nextTripStop,
    required int totalTripsThisMonth,
    required int attendedTrips,
    String? assignedRoute,
    String? assignedStop,
  }) = _EmployeeDashboard;

  factory EmployeeDashboard.fromJson(Map<String, dynamic> json) => _$EmployeeDashboardFromJson(json);
}

@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, dynamic> summary,
    required List<Map<String, dynamic>> details,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);
}
