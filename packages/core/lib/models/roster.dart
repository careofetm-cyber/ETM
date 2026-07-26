import 'package:freezed_annotation/freezed_annotation.dart';

part 'roster.freezed.dart';
part 'roster.g.dart';

@freezed
class Roster with _$Roster {
  const factory Roster({
    required String id,
    @JsonKey(name: 'employee_id') required String employeeId,
    @JsonKey(name: 'company_id') required String companyId,
    required String date,
    @JsonKey(name: 'route_id') String? routeId,
    @JsonKey(name: 'stop_id') String? stopId,
    @JsonKey(name: 'shift_type') @Default('morning') String shiftType,
    @Default('pending') String status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Roster;

  factory Roster.fromJson(Map<String, dynamic> json) => _$RosterFromJson(json);
}

@freezed
class RosterRequest with _$RosterRequest {
  const factory RosterRequest({
    required String id,
    @JsonKey(name: 'employee_id') required String employeeId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'request_type') @Default('schedule_change') String requestType,
    @JsonKey(name: 'current_date') String? currentDate,
    @JsonKey(name: 'requested_date') String? requestedDate,
    @JsonKey(name: 'current_route_id') String? currentRouteId,
    @JsonKey(name: 'requested_route_id') String? requestedRouteId,
    @JsonKey(name: 'current_stop_id') String? currentStopId,
    @JsonKey(name: 'requested_stop_id') String? requestedStopId,
    String? reason,
    @Default('pending') String status,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'approved_at') String? approvedAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _RosterRequest;

  factory RosterRequest.fromJson(Map<String, dynamic> json) => _$RosterRequestFromJson(json);
}
