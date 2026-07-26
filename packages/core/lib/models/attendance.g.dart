// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceImpl _$$AttendanceImplFromJson(Map<String, dynamic> json) =>
    _$AttendanceImpl(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      date: DateTime.parse(json['date'] as String),
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      tripId: json['tripId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      boardingMethod:
          $enumDecodeNullable(_$BoardingMethodEnumMap, json['boardingMethod']),
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      checkInLocation: json['checkInLocation'] as String?,
      checkOutLocation: json['checkOutLocation'] as String?,
      companyId: json['companyId'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AttendanceImplToJson(_$AttendanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'date': instance.date.toIso8601String(),
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'tripId': instance.tripId,
      'vehicleId': instance.vehicleId,
      'boardingMethod': _$BoardingMethodEnumMap[instance.boardingMethod],
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'checkInLocation': instance.checkInLocation,
      'checkOutLocation': instance.checkOutLocation,
      'companyId': instance.companyId,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.late: 'late',
  AttendanceStatus.halfDay: 'halfDay',
  AttendanceStatus.onLeave: 'onLeave',
};

const _$BoardingMethodEnumMap = {
  BoardingMethod.qr: 'qr',
  BoardingMethod.manual: 'manual',
  BoardingMethod.gps: 'gps',
};

_$TransportRequestImpl _$$TransportRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TransportRequestImpl(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      companyId: json['companyId'] as String,
      type: $enumDecode(_$TransportRequestTypeEnumMap, json['type']),
      status: $enumDecode(_$TransportRequestStatusEnumMap, json['status']),
      routeId: json['routeId'] as String?,
      stopId: json['stopId'] as String?,
      effectiveFrom: json['effectiveFrom'] == null
          ? null
          : DateTime.parse(json['effectiveFrom'] as String),
      effectiveTo: json['effectiveTo'] == null
          ? null
          : DateTime.parse(json['effectiveTo'] as String),
      reason: json['reason'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      approvedBy: json['approvedBy'] as String?,
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TransportRequestImplToJson(
        _$TransportRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'companyId': instance.companyId,
      'type': _$TransportRequestTypeEnumMap[instance.type]!,
      'status': _$TransportRequestStatusEnumMap[instance.status]!,
      'routeId': instance.routeId,
      'stopId': instance.stopId,
      'effectiveFrom': instance.effectiveFrom?.toIso8601String(),
      'effectiveTo': instance.effectiveTo?.toIso8601String(),
      'reason': instance.reason,
      'rejectionReason': instance.rejectionReason,
      'approvedBy': instance.approvedBy,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TransportRequestTypeEnumMap = {
  TransportRequestType.newRequest: 'newRequest',
  TransportRequestType.routeChange: 'routeChange',
  TransportRequestType.stopChange: 'stopChange',
  TransportRequestType.cancellation: 'cancellation',
};

const _$TransportRequestStatusEnumMap = {
  TransportRequestStatus.pending: 'pending',
  TransportRequestStatus.approved: 'approved',
  TransportRequestStatus.rejected: 'rejected',
  TransportRequestStatus.cancelled: 'cancelled',
};
