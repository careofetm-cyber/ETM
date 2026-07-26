import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

enum VehicleStatus { active, inactive, maintenance, offline }

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String plateNumber,
    required String model,
    required String brand,
    required int year,
    required int seatingCapacity,
    String? color,
    String? imageUrl,
    VehicleStatus? status,
    String? driverId,
    String? companyId,
    double? currentLatitude,
    double? currentLongitude,
    DateTime? lastLocationUpdate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  const Vehicle._();

  String get displayName => '$brand $model ($plateNumber)';
}

@freezed
class VehicleInspection with _$VehicleInspection {
  const factory VehicleInspection({
    required String id,
    required String vehicleId,
    required String driverId,
    required DateTime inspectionDate,
    required bool isPassed,
    String? notes,
    List<String>? issues,
    DateTime? createdAt,
  }) = _VehicleInspection;

  factory VehicleInspection.fromJson(Map<String, dynamic> json) => _$VehicleInspectionFromJson(json);
}
