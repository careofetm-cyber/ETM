// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RosterImpl _$$RosterImplFromJson(Map<String, dynamic> json) => _$RosterImpl(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      companyId: json['company_id'] as String,
      date: json['date'] as String,
      routeId: json['route_id'] as String?,
      stopId: json['stop_id'] as String?,
      shiftType: json['shift_type'] as String? ?? 'morning',
      status: json['status'] as String? ?? 'pending',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$RosterImplToJson(_$RosterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'company_id': instance.companyId,
      'date': instance.date,
      'route_id': instance.routeId,
      'stop_id': instance.stopId,
      'shift_type': instance.shiftType,
      'status': instance.status,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$RosterRequestImpl _$$RosterRequestImplFromJson(Map<String, dynamic> json) =>
    _$RosterRequestImpl(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      companyId: json['company_id'] as String,
      requestType: json['request_type'] as String? ?? 'schedule_change',
      currentDate: json['current_date'] as String?,
      requestedDate: json['requested_date'] as String?,
      currentRouteId: json['current_route_id'] as String?,
      requestedRouteId: json['requested_route_id'] as String?,
      currentStopId: json['current_stop_id'] as String?,
      requestedStopId: json['requested_stop_id'] as String?,
      reason: json['reason'] as String?,
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$RosterRequestImplToJson(_$RosterRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'company_id': instance.companyId,
      'request_type': instance.requestType,
      'current_date': instance.currentDate,
      'requested_date': instance.requestedDate,
      'current_route_id': instance.currentRouteId,
      'requested_route_id': instance.requestedRouteId,
      'current_stop_id': instance.currentStopId,
      'requested_stop_id': instance.requestedStopId,
      'reason': instance.reason,
      'status': instance.status,
      'rejection_reason': instance.rejectionReason,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt,
      'created_at': instance.createdAt,
    };
