// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncidentImpl _$$IncidentImplFromJson(Map<String, dynamic> json) =>
    _$IncidentImpl(
      id: json['id'] as String,
      reportedBy: json['reportedBy'] as String,
      vehicleId: json['vehicleId'] as String?,
      tripId: json['tripId'] as String?,
      driverId: json['driverId'] as String?,
      severity: $enumDecode(_$IncidentSeverityEnumMap, json['severity']),
      status: $enumDecode(_$IncidentStatusEnumMap, json['status']),
      description: json['description'] as String,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      incidentTime: json['incidentTime'] == null
          ? null
          : DateTime.parse(json['incidentTime'] as String),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      resolution: json['resolution'] as String?,
      resolvedBy: json['resolvedBy'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      companyId: json['companyId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$IncidentImplToJson(_$IncidentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reportedBy': instance.reportedBy,
      'vehicleId': instance.vehicleId,
      'tripId': instance.tripId,
      'driverId': instance.driverId,
      'severity': _$IncidentSeverityEnumMap[instance.severity]!,
      'status': _$IncidentStatusEnumMap[instance.status]!,
      'description': instance.description,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'incidentTime': instance.incidentTime?.toIso8601String(),
      'imageUrls': instance.imageUrls,
      'resolution': instance.resolution,
      'resolvedBy': instance.resolvedBy,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'companyId': instance.companyId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$IncidentSeverityEnumMap = {
  IncidentSeverity.low: 'low',
  IncidentSeverity.medium: 'medium',
  IncidentSeverity.high: 'high',
  IncidentSeverity.critical: 'critical',
};

const _$IncidentStatusEnumMap = {
  IncidentStatus.reported: 'reported',
  IncidentStatus.investigating: 'investigating',
  IncidentStatus.resolved: 'resolved',
  IncidentStatus.closed: 'closed',
};

_$SOSAlertImpl _$$SOSAlertImplFromJson(Map<String, dynamic> json) =>
    _$SOSAlertImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userType: json['userType'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      message: json['message'] as String?,
      isResolved: json['isResolved'] as bool,
      resolvedBy: json['resolvedBy'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      companyId: json['companyId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SOSAlertImplToJson(_$SOSAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userType': instance.userType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'message': instance.message,
      'isResolved': instance.isResolved,
      'resolvedBy': instance.resolvedBy,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'companyId': instance.companyId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
