// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String,
      plateNumber: json['plateNumber'] as String,
      model: json['model'] as String,
      brand: json['brand'] as String,
      year: (json['year'] as num).toInt(),
      seatingCapacity: (json['seatingCapacity'] as num).toInt(),
      color: json['color'] as String?,
      imageUrl: json['imageUrl'] as String?,
      status: $enumDecodeNullable(_$VehicleStatusEnumMap, json['status']),
      driverId: json['driverId'] as String?,
      companyId: json['companyId'] as String?,
      currentLatitude: (json['currentLatitude'] as num?)?.toDouble(),
      currentLongitude: (json['currentLongitude'] as num?)?.toDouble(),
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
