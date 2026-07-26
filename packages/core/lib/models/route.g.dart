// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteImpl _$$RouteImplFromJson(Map<String, dynamic> json) => _$RouteImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      companyId: json['companyId'] as String,
      description: json['description'] as String?,
      stops: (json['stops'] as List<dynamic>)
          .map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
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
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      sequenceOrder: (json['sequenceOrder'] as num).toInt(),
      address: json['address'] as String?,
      landmark: json['landmark'] as String?,
      estimatedTimeFromPrevious:
          (json['estimatedTimeFromPrevious'] as num?)?.toInt(),
      distanceFromPrevious: (json['distanceFromPrevious'] as num?)?.toDouble(),
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
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
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
