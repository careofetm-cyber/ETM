import 'package:freezed_annotation/freezed_annotation.dart';

part 'hcm_config.freezed.dart';
part 'hcm_config.g.dart';

@freezed
class HcmConfig with _$HcmConfig {
  const factory HcmConfig({
    required String id,
    @JsonKey(name: 'company_id') required String companyId,
    required String provider,
    @JsonKey(name: 'api_endpoint') String? apiEndpoint,
    @JsonKey(name: 'api_key') String? apiKey,
    @JsonKey(name: 'sync_employees') @Default(true) bool syncEmployees,
    @JsonKey(name: 'sync_attendance') @Default(false) bool syncAttendance,
    @JsonKey(name: 'sync_interval_hours') @Default(24) int syncIntervalHours,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_sync_at') String? lastSyncAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _HcmConfig;

  factory HcmConfig.fromJson(Map<String, dynamic> json) => _$HcmConfigFromJson(json);
}
