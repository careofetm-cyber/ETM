// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      totalVehicles: (json['totalVehicles'] as num).toInt(),
      activeVehicles: (json['activeVehicles'] as num).toInt(),
      totalDrivers: (json['totalDrivers'] as num).toInt(),
      activeDrivers: (json['activeDrivers'] as num).toInt(),
      totalEmployees: (json['totalEmployees'] as num).toInt(),
      activeTrips: (json['activeTrips'] as num).toInt(),
      completedTripsToday: (json['completedTripsToday'] as num).toInt(),
      pendingRequests: (json['pendingRequests'] as num).toInt(),
      totalRoutes: (json['totalRoutes'] as num).toInt(),
      alertsCount: (json['alertsCount'] as num?)?.toInt(),
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
      todayTrips: (json['todayTrips'] as num).toInt(),
      completedTrips: (json['completedTrips'] as num).toInt(),
      pendingTrips: (json['pendingTrips'] as num).toInt(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      totalPassengers: (json['totalPassengers'] as num).toInt(),
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
      totalTripsThisMonth: (json['totalTripsThisMonth'] as num).toInt(),
      attendedTrips: (json['attendedTrips'] as num).toInt(),
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
