// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      vehicleId: json['vehicleId'] as String,
      driverId: json['driverId'] as String,
      type: $enumDecode(_$TripTypeEnumMap, json['type']),
      status: $enumDecode(_$TripStatusEnumMap, json['status']),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      actualStartTime: json['actualStartTime'] == null
          ? null
          : DateTime.parse(json['actualStartTime'] as String),
      actualEndTime: json['actualEndTime'] == null
          ? null
          : DateTime.parse(json['actualEndTime'] as String),
      companyId: json['companyId'] as String?,
      totalPassengers: (json['totalPassengers'] as num?)?.toInt(),
      boardedPassengers: (json['boardedPassengers'] as num?)?.toInt(),
      totalDistance: (json['totalDistance'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'vehicleId': instance.vehicleId,
      'driverId': instance.driverId,
      'type': _$TripTypeEnumMap[instance.type]!,
      'status': _$TripStatusEnumMap[instance.status]!,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'actualStartTime': instance.actualStartTime?.toIso8601String(),
      'actualEndTime': instance.actualEndTime?.toIso8601String(),
      'companyId': instance.companyId,
      'totalPassengers': instance.totalPassengers,
      'boardedPassengers': instance.boardedPassengers,
      'totalDistance': instance.totalDistance,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TripTypeEnumMap = {
  TripType.pickup: 'pickup',
  TripType.dropoff: 'dropoff',
};

const _$TripStatusEnumMap = {
  TripStatus.scheduled: 'scheduled',
  TripStatus.inProgress: 'inProgress',
  TripStatus.completed: 'completed',
  TripStatus.cancelled: 'cancelled',
};

_$TripPassengerImpl _$$TripPassengerImplFromJson(Map<String, dynamic> json) =>
    _$TripPassengerImpl(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      employeeId: json['employeeId'] as String,
      stopId: json['stopId'] as String,
      isBoarded: json['isBoarded'] as bool?,
      isDropped: json['isDropped'] as bool?,
      boardedAt: json['boardedAt'] == null
          ? null
          : DateTime.parse(json['boardedAt'] as String),
      droppedAt: json['droppedAt'] == null
          ? null
          : DateTime.parse(json['droppedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TripPassengerImplToJson(_$TripPassengerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'employeeId': instance.employeeId,
      'stopId': instance.stopId,
      'isBoarded': instance.isBoarded,
      'isDropped': instance.isDropped,
      'boardedAt': instance.boardedAt?.toIso8601String(),
      'droppedAt': instance.droppedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$GPSLogImpl _$$GPSLogImplFromJson(Map<String, dynamic> json) => _$GPSLogImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      tripId: json['tripId'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$GPSLogImplToJson(_$GPSLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'tripId': instance.tripId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'speed': instance.speed,
      'heading': instance.heading,
      'altitude': instance.altitude,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$LocationUpdateImpl _$$LocationUpdateImplFromJson(Map<String, dynamic> json) =>
    _$LocationUpdateImpl(
      vehicleId: json['vehicleId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$LocationUpdateImplToJson(
        _$LocationUpdateImpl instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'speed': instance.speed,
      'heading': instance.heading,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
