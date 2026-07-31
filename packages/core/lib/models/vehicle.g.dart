// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

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

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String,
      plateNumber: json['plateNumber'] as String,
      model: json['model'] as String,
      brand: json['brand'] as String,
      year: _toInt(json['year']) ?? 2024,
      seatingCapacity: _toInt(json['seatingCapacity']) ?? 4,
      color: json['color'] as String?,
      imageUrl: json['imageUrl'] as String?,
      status: $enumDecodeNullable(_$VehicleStatusEnumMap, json['status']),
      driverId: json['driverId'] as String?,
      companyId: json['companyId'] as String?,
      currentLatitude: _toDouble(json['currentLatitude']),
      currentLongitude: _toDouble(json['currentLongitude']),
      lastLocationUpdate: json['lastLocationUpdate'] == null
          ? null
          : DateTime.parse(json['lastLocationUpdate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plateNumber': instance.plateNumber,
      'model': instance.model,
      'brand': instance.brand,
      'year': instance.year,
      'seatingCapacity': instance.seatingCapacity,
      'color': instance.color,
      'imageUrl': instance.imageUrl,
      'status': _$VehicleStatusEnumMap[instance.status],
      'driverId': instance.driverId,
      'companyId': instance.companyId,
      'currentLatitude': instance.currentLatitude,
      'currentLongitude': instance.currentLongitude,
      'lastLocationUpdate': instance.lastLocationUpdate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$VehicleStatusEnumMap = {
  VehicleStatus.active: 'active',
  VehicleStatus.inactive: 'inactive',
  VehicleStatus.maintenance: 'maintenance',
  VehicleStatus.offline: 'offline',
};

_$VehicleInspectionImpl _$$VehicleInspectionImplFromJson(
        Map<String, dynamic> json) =>
    _$VehicleInspectionImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      driverId: json['driverId'] as String,
      inspectionDate: DateTime.parse(json['inspectionDate'] as String),
      isPassed: json['isPassed'] as bool,
      notes: json['notes'] as String?,
      issues:
          (json['issues'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VehicleInspectionImplToJson(
        _$VehicleInspectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'driverId': instance.driverId,
      'inspectionDate': instance.inspectionDate.toIso8601String(),
      'isPassed': instance.isPassed,
      'notes': instance.notes,
      'issues': instance.issues,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
