// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      totalVehicles: _toInt(json['totalVehicles']) ?? 0,
      activeVehicles: _toInt(json['activeVehicles']) ?? 0,
      totalDrivers: _toInt(json['totalDrivers']) ?? 0,
      activeDrivers: _toInt(json['activeDrivers']) ?? 0,
      totalEmployees: _toInt(json['totalEmployees']) ?? 0,
      activeTrips: _toInt(json['activeTrips']) ?? 0,
      completedTripsToday: _toInt(json['completedTripsToday']) ?? 0,
      pendingRequests: _toInt(json['pendingRequests']) ?? 0,
      totalRoutes: _toInt(json['totalRoutes']) ?? 0,
      alertsCount: _toInt(json['alertsCount']),
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
        _$DashboardStatsImpl instance) =>
    <String, dynamic>{
      'totalVehicles': instance.totalVehicles,
      'activeVehicles': instance.activeVehicles,
      'totalDrivers': instance.totalDrivers,
      'activeDrivers': instance.activeDrivers,
      'totalEmployees': instance.totalEmployees,
      'activeTrips': instance.activeTrips,
      'completedTripsToday': instance.completedTripsToday,
      'pendingRequests': instance.pendingRequests,
      'totalRoutes': instance.totalRoutes,
      'alertsCount': instance.alertsCount,
    };

_$DriverDashboardImpl _$$DriverDashboardImplFromJson(
        Map<String, dynamic> json) =>
    _$DriverDashboardImpl(
      todayTrips: _toInt(json['todayTrips']) ?? 0,
      completedTrips: _toInt(json['completedTrips']) ?? 0,
      pendingTrips: _toInt(json['pendingTrips']) ?? 0,
      totalDistance: _toDouble(json['totalDistance']) ?? 0.0,
      totalPassengers: _toInt(json['totalPassengers']) ?? 0,
      assignedVehicle: json['assignedVehicle'] as String?,
      currentTripId: json['currentTripId'] as String?,
    );

Map<String, dynamic> _$$DriverDashboardImplToJson(
        _$DriverDashboardImpl instance) =>
    <String, dynamic>{
      'todayTrips': instance.todayTrips,
      'completedTrips': instance.completedTrips,
      'pendingTrips': instance.pendingTrips,
      'totalDistance': instance.totalDistance,
      'totalPassengers': instance.totalPassengers,
      'assignedVehicle': instance.assignedVehicle,
      'currentTripId': instance.currentTripId,
    };

_$EmployeeDashboardImpl _$$EmployeeDashboardImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeDashboardImpl(
      hasUpcomingTrip: json['hasUpcomingTrip'] as bool,
      nextTripId: json['nextTripId'] as String?,
      nextTripTime: json['nextTripTime'] == null
          ? null
          : DateTime.parse(json['nextTripTime'] as String),
      nextTripRoute: json['nextTripRoute'] as String?,
      nextTripStop: json['nextTripStop'] as String?,
      totalTripsThisMonth: _toInt(json['totalTripsThisMonth']) ?? 0,
      attendedTrips: _toInt(json['attendedTrips']) ?? 0,
      assignedRoute: json['assignedRoute'] as String?,
      assignedStop: json['assignedStop'] as String?,
    );

Map<String, dynamic> _$$EmployeeDashboardImplToJson(
        _$EmployeeDashboardImpl instance) =>
    <String, dynamic>{
      'hasUpcomingTrip': instance.hasUpcomingTrip,
      'nextTripId': instance.nextTripId,
      'nextTripTime': instance.nextTripTime?.toIso8601String(),
      'nextTripRoute': instance.nextTripRoute,
      'nextTripStop': instance.nextTripStop,
      'totalTripsThisMonth': instance.totalTripsThisMonth,
      'attendedTrips': instance.attendedTrips,
      'assignedRoute': instance.assignedRoute,
      'assignedStop': instance.assignedStop,
    };

_$ReportDataImpl _$$ReportDataImplFromJson(Map<String, dynamic> json) =>
    _$ReportDataImpl(
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      summary: json['summary'] as Map<String, dynamic>,
      details: (json['details'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$ReportDataImplToJson(_$ReportDataImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'summary': instance.summary,
      'details': instance.details,
    };
