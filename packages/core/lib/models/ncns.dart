import 'package:freezed_annotation/freezed_annotation.dart';

part 'ncns.freezed.dart';
part 'ncns.g.dart';

@freezed
class NcnsLog with _$NcnsLog {
  const factory NcnsLog({
    required String id,
    @JsonKey(name: 'employee_id') required String employeeId,
    @JsonKey(name: 'company_id') required String companyId,
    String? date,
    String? reason,
    @JsonKey(name: 'marked_by') String? markedBy,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _NcnsLog;

  factory NcnsLog.fromJson(Map<String, dynamic> json) => _$NcnsLogFromJson(json);
}

@freezed
class NcnsSettings with _$NcnsSettings {
  const factory NcnsSettings({
    @JsonKey(name: 'ncns_threshold') @Default(3) int ncnsThreshold,
    @JsonKey(name: 'auto_disable') @Default(true) bool autoDisable,
  }) = _NcnsSettings;

  factory NcnsSettings.fromJson(Map<String, dynamic> json) => _$NcnsSettingsFromJson(json);
}
