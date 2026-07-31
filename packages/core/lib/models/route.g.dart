// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

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

_$RouteImpl _$$RouteImplFromJson(Map<String, dynamic> json) => _$RouteImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      companyId: json['companyId'] as String,
      description: json['description'] as String?,
      stops: (json['stops'] as List<dynamic>?)
          ?.map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDistance: _toDouble(json['totalDistance']),
      estimatedDuration: _toInt(json['estimatedDuration']),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RouteImplToJson(_$RouteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'companyId': instance.companyId,
      'description': instance.description,
      'stops': instance.stops,
      'totalDistance': instance.totalDistance,
      'estimatedDuration': instance.estimatedDuration,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$RouteStopImpl _$$RouteStopImplFromJson(Map<String, dynamic> json) =>
    _$RouteStopImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: _toDouble(json['latitude']) ?? 0.0,
      longitude: _toDouble(json['longitude']) ?? 0.0,
      sequenceOrder: _toInt(json['sequenceOrder']) ?? 0,
      address: json['address'] as String?,
      landmark: json['landmark'] as String?,
      estimatedTimeFromPrevious:
          _toInt(json['estimatedTimeFromPrevious']),
      distanceFromPrevious: _toDouble(json['distanceFromPrevious']),
    );

Map<String, dynamic> _$$RouteStopImplToJson(_$RouteStopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'sequenceOrder': instance.sequenceOrder,
      'address': instance.address,
      'landmark': instance.landmark,
      'estimatedTimeFromPrevious': instance.estimatedTimeFromPrevious,
      'distanceFromPrevious': instance.distanceFromPrevious,
    };

_$StopImpl _$$StopImplFromJson(Map<String, dynamic> json) => _$StopImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: _toDouble(json['latitude']) ?? 0.0,
      longitude: _toDouble(json['longitude']) ?? 0.0,
      address: json['address'] as String?,
      landmark: json['landmark'] as String?,
      companyId: json['companyId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StopImplToJson(_$StopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'landmark': instance.landmark,
      'companyId': instance.companyId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
