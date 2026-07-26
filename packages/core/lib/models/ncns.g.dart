// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ncns.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NcnsLogImpl _$$NcnsLogImplFromJson(Map<String, dynamic> json) =>
    _$NcnsLogImpl(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      companyId: json['company_id'] as String,
      date: json['date'] as String?,
      reason: json['reason'] as String?,
      markedBy: json['marked_by'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$NcnsLogImplToJson(_$NcnsLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'company_id': instance.companyId,
      'date': instance.date,
      'reason': instance.reason,
      'marked_by': instance.markedBy,
      'created_at': instance.createdAt,
    };

_$NcnsSettingsImpl _$$NcnsSettingsImplFromJson(Map<String, dynamic> json) =>
    _$NcnsSettingsImpl(
      ncnsThreshold: (json['ncns_threshold'] as num?)?.toInt() ?? 3,
      autoDisable: json['auto_disable'] as bool? ?? true,
    );

Map<String, dynamic> _$$NcnsSettingsImplToJson(_$NcnsSettingsImpl instance) =>
    <String, dynamic>{
      'ncns_threshold': instance.ncnsThreshold,
      'auto_disable': instance.autoDisable,
    };
