import 'package:freezed_annotation/freezed_annotation.dart';

part 'fuel.freezed.dart';
part 'fuel.g.dart';

@freezed
class FuelLog with _$FuelLog {
  const factory FuelLog({
    required String id,
    required String vehicleId,
    required String driverId,
    required DateTime date,
    required double amount,
    required double pricePerUnit,
    required double totalCost,
    required double odometerReading,
    String? fuelType,
    String? gasStation,
    String? notes,
    DateTime? createdAt,
  }) = _FuelLog;

  factory FuelLog.fromJson(Map<String, dynamic> json) => _$FuelLogFromJson(json);
}

@freezed
class Maintenance with _$Maintenance {
  const factory Maintenance({
    required String id,
    required String vehicleId,
    required MaintenanceType type,
    required DateTime scheduledDate,
    DateTime? completedDate,
    required MaintenanceStatus status,
    String? description,
    double? cost,
    String? serviceProvider,
    int? odometerAtService,
    int? nextServiceOdometer,
    DateTime? nextServiceDate,
    String? notes,
    List<String>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Maintenance;

  factory Maintenance.fromJson(Map<String, dynamic> json) => _$MaintenanceFromJson(json);
}

enum MaintenanceType {
  regularService,
  oilChange,
  tireRotation,
  brakeService,
  batteryReplacement,
  engineRepair,
  bodyWork,
  other
}

enum MaintenanceStatus { scheduled, inProgress, completed, overdue }
