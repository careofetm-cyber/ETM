// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hcm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HcmConfigImpl _$$HcmConfigImplFromJson(Map<String, dynamic> json) =>
    _$HcmConfigImpl(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      provider: json['provider'] as String,
      apiEndpoint: json['api_endpoint'] as String?,
      apiKey: json['api_key'] as String?,
      syncEmployees: json['sync_employees'] as bool? ?? true,
      syncAttendance: json['sync_attendance'] as bool? ?? false,
      syncIntervalHours: (json['sync_interval_hours'] as num?)?.toInt() ?? 24,
      isActive: json['is_active'] as bool? ?? true,
      lastSyncAt: json['last_sync_at'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$HcmConfigImplToJson(_$HcmConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'provider': instance.provider,
      'api_endpoint': instance.apiEndpoint,
      'api_key': instance.apiKey,
      'sync_employees': instance.syncEmployees,
      'sync_attendance': instance.syncAttendance,
      'sync_interval_hours': instance.syncIntervalHours,
      'is_active': instance.isActive,
      'last_sync_at': instance.lastSyncAt,
      'created_at': instance.createdAt,
    };
