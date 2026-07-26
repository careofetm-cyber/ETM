// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roster.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Roster _$RosterFromJson(Map<String, dynamic> json) {
  return _Roster.fromJson(json);
}

/// @nodoc
mixin _$Roster {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id')
  String get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'route_id')
  String? get routeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_id')
  String? get stopId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_type')
  String get shiftType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Roster to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Roster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RosterCopyWith<Roster> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RosterCopyWith<$Res> {
  factory $RosterCopyWith(Roster value, $Res Function(Roster) then) =
      _$RosterCopyWithImpl<$Res, Roster>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'company_id') String companyId,
      String date,
      @JsonKey(name: 'route_id') String? routeId,
      @JsonKey(name: 'stop_id') String? stopId,
      @JsonKey(name: 'shift_type') String shiftType,
      String status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$RosterCopyWithImpl<$Res, $Val extends Roster>
    implements $RosterCopyWith<$Res> {
  _$RosterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Roster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? date = null,
    Object? routeId = freezed,
    Object? stopId = freezed,
    Object? shiftType = null,
    Object? status = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      stopId: freezed == stopId
          ? _value.stopId
          : stopId // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RosterImplCopyWith<$Res> implements $RosterCopyWith<$Res> {
  factory _$$RosterImplCopyWith(
          _$RosterImpl value, $Res Function(_$RosterImpl) then) =
      __$$RosterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'company_id') String companyId,
      String date,
      @JsonKey(name: 'route_id') String? routeId,
      @JsonKey(name: 'stop_id') String? stopId,
      @JsonKey(name: 'shift_type') String shiftType,
      String status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$RosterImplCopyWithImpl<$Res>
    extends _$RosterCopyWithImpl<$Res, _$RosterImpl>
    implements _$$RosterImplCopyWith<$Res> {
  __$$RosterImplCopyWithImpl(
      _$RosterImpl _value, $Res Function(_$RosterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Roster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? date = null,
    Object? routeId = freezed,
    Object? stopId = freezed,
    Object? shiftType = null,
    Object? status = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RosterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      stopId: freezed == stopId
          ? _value.stopId
          : stopId // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RosterImpl implements _Roster {
  const _$RosterImpl(
      {required this.id,
      @JsonKey(name: 'employee_id') required this.employeeId,
      @JsonKey(name: 'company_id') required this.companyId,
      required this.date,
      @JsonKey(name: 'route_id') this.routeId,
      @JsonKey(name: 'stop_id') this.stopId,
      @JsonKey(name: 'shift_type') this.shiftType = 'morning',
      this.status = 'pending',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$RosterImpl.fromJson(Map<String, dynamic> json) =>
      _$$RosterImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'employee_id')
  final String employeeId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  final String date;
  @override
  @JsonKey(name: 'route_id')
  final String? routeId;
  @override
  @JsonKey(name: 'stop_id')
  final String? stopId;
  @override
  @JsonKey(name: 'shift_type')
  final String shiftType;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'Roster(id: $id, employeeId: $employeeId, companyId: $companyId, date: $date, routeId: $routeId, stopId: $stopId, shiftType: $shiftType, status: $status, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RosterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.stopId, stopId) || other.stopId == stopId) &&
            (identical(other.shiftType, shiftType) ||
                other.shiftType == shiftType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, employeeId, companyId, date,
      routeId, stopId, shiftType, status, isActive, createdAt, updatedAt);

  /// Create a copy of Roster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RosterImplCopyWith<_$RosterImpl> get copyWith =>
      __$$RosterImplCopyWithImpl<_$RosterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RosterImplToJson(
      this,
    );
  }
}

abstract class _Roster implements Roster {
  const factory _Roster(
      {required final String id,
      @JsonKey(name: 'employee_id') required final String employeeId,
      @JsonKey(name: 'company_id') required final String companyId,
      required final String date,
      @JsonKey(name: 'route_id') final String? routeId,
      @JsonKey(name: 'stop_id') final String? stopId,
      @JsonKey(name: 'shift_type') final String shiftType,
      final String status,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt}) = _$RosterImpl;

  factory _Roster.fromJson(Map<String, dynamic> json) = _$RosterImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'employee_id')
  String get employeeId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  String get date;
  @override
  @JsonKey(name: 'route_id')
  String? get routeId;
  @override
  @JsonKey(name: 'stop_id')
  String? get stopId;
  @override
  @JsonKey(name: 'shift_type')
  String get shiftType;
  @override
  String get status;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of Roster
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RosterImplCopyWith<_$RosterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RosterRequest _$RosterRequestFromJson(Map<String, dynamic> json) {
  return _RosterRequest.fromJson(json);
}

/// @nodoc
mixin _$RosterRequest {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id')
  String get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_type')
  String get requestType => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_date')
  String? get currentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_date')
  String? get requestedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_route_id')
  String? get currentRouteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_route_id')
  String? get requestedRouteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stop_id')
  String? get currentStopId => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_stop_id')
  String? get requestedStopId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  String? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RosterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RosterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RosterRequestCopyWith<RosterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RosterRequestCopyWith<$Res> {
  factory $RosterRequestCopyWith(
          RosterRequest value, $Res Function(RosterRequest) then) =
      _$RosterRequestCopyWithImpl<$Res, RosterRequest>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'request_type') String requestType,
      @JsonKey(name: 'current_date') String? currentDate,
      @JsonKey(name: 'requested_date') String? requestedDate,
      @JsonKey(name: 'current_route_id') String? currentRouteId,
      @JsonKey(name: 'requested_route_id') String? requestedRouteId,
      @JsonKey(name: 'current_stop_id') String? currentStopId,
      @JsonKey(name: 'requested_stop_id') String? requestedStopId,
      String? reason,
      String status,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') String? approvedAt,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$RosterRequestCopyWithImpl<$Res, $Val extends RosterRequest>
    implements $RosterRequestCopyWith<$Res> {
  _$RosterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RosterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? requestType = null,
    Object? currentDate = freezed,
    Object? requestedDate = freezed,
    Object? currentRouteId = freezed,
    Object? requestedRouteId = freezed,
    Object? currentStopId = freezed,
    Object? requestedStopId = freezed,
    Object? reason = freezed,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      currentDate: freezed == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedDate: freezed == requestedDate
          ? _value.requestedDate
          : requestedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      currentRouteId: freezed == currentRouteId
          ? _value.currentRouteId
          : currentRouteId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedRouteId: freezed == requestedRouteId
          ? _value.requestedRouteId
          : requestedRouteId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStopId: freezed == currentStopId
          ? _value.currentStopId
          : currentStopId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedStopId: freezed == requestedStopId
          ? _value.requestedStopId
          : requestedStopId // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RosterRequestImplCopyWith<$Res>
    implements $RosterRequestCopyWith<$Res> {
  factory _$$RosterRequestImplCopyWith(
          _$RosterRequestImpl value, $Res Function(_$RosterRequestImpl) then) =
      __$$RosterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'request_type') String requestType,
      @JsonKey(name: 'current_date') String? currentDate,
      @JsonKey(name: 'requested_date') String? requestedDate,
      @JsonKey(name: 'current_route_id') String? currentRouteId,
      @JsonKey(name: 'requested_route_id') String? requestedRouteId,
      @JsonKey(name: 'current_stop_id') String? currentStopId,
      @JsonKey(name: 'requested_stop_id') String? requestedStopId,
      String? reason,
      String status,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') String? approvedAt,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$RosterRequestImplCopyWithImpl<$Res>
    extends _$RosterRequestCopyWithImpl<$Res, _$RosterRequestImpl>
    implements _$$RosterRequestImplCopyWith<$Res> {
  __$$RosterRequestImplCopyWithImpl(
      _$RosterRequestImpl _value, $Res Function(_$RosterRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RosterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? requestType = null,
    Object? currentDate = freezed,
    Object? requestedDate = freezed,
    Object? currentRouteId = freezed,
    Object? requestedRouteId = freezed,
    Object? currentStopId = freezed,
    Object? requestedStopId = freezed,
    Object? reason = freezed,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$RosterRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as String,
      currentDate: freezed == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedDate: freezed == requestedDate
          ? _value.requestedDate
          : requestedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      currentRouteId: freezed == currentRouteId
          ? _value.currentRouteId
          : currentRouteId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedRouteId: freezed == requestedRouteId
          ? _value.requestedRouteId
          : requestedRouteId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStopId: freezed == currentStopId
          ? _value.currentStopId
          : currentStopId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedStopId: freezed == requestedStopId
          ? _value.requestedStopId
          : requestedStopId // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RosterRequestImpl implements _RosterRequest {
  const _$RosterRequestImpl(
      {required this.id,
      @JsonKey(name: 'employee_id') required this.employeeId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'request_type') this.requestType = 'schedule_change',
      @JsonKey(name: 'current_date') this.currentDate,
      @JsonKey(name: 'requested_date') this.requestedDate,
      @JsonKey(name: 'current_route_id') this.currentRouteId,
      @JsonKey(name: 'requested_route_id') this.requestedRouteId,
      @JsonKey(name: 'current_stop_id') this.currentStopId,
      @JsonKey(name: 'requested_stop_id') this.requestedStopId,
      this.reason,
      this.status = 'pending',
      @JsonKey(name: 'rejection_reason') this.rejectionReason,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'approved_at') this.approvedAt,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$RosterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RosterRequestImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'employee_id')
  final String employeeId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'request_type')
  final String requestType;
  @override
  @JsonKey(name: 'current_date')
  final String? currentDate;
  @override
  @JsonKey(name: 'requested_date')
  final String? requestedDate;
  @override
  @JsonKey(name: 'current_route_id')
  final String? currentRouteId;
  @override
  @JsonKey(name: 'requested_route_id')
  final String? requestedRouteId;
  @override
  @JsonKey(name: 'current_stop_id')
  final String? currentStopId;
  @override
  @JsonKey(name: 'requested_stop_id')
  final String? requestedStopId;
  @override
  final String? reason;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'RosterRequest(id: $id, employeeId: $employeeId, companyId: $companyId, requestType: $requestType, currentDate: $currentDate, requestedDate: $requestedDate, currentRouteId: $currentRouteId, requestedRouteId: $requestedRouteId, currentStopId: $currentStopId, requestedStopId: $requestedStopId, reason: $reason, status: $status, rejectionReason: $rejectionReason, approvedBy: $approvedBy, approvedAt: $approvedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RosterRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.currentDate, currentDate) ||
                other.currentDate == currentDate) &&
            (identical(other.requestedDate, requestedDate) ||
                other.requestedDate == requestedDate) &&
            (identical(other.currentRouteId, currentRouteId) ||
                other.currentRouteId == currentRouteId) &&
            (identical(other.requestedRouteId, requestedRouteId) ||
                other.requestedRouteId == requestedRouteId) &&
            (identical(other.currentStopId, currentStopId) ||
                other.currentStopId == currentStopId) &&
            (identical(other.requestedStopId, requestedStopId) ||
                other.requestedStopId == requestedStopId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      companyId,
      requestType,
      currentDate,
      requestedDate,
      currentRouteId,
      requestedRouteId,
      currentStopId,
      requestedStopId,
      reason,
      status,
      rejectionReason,
      approvedBy,
      approvedAt,
      createdAt);

  /// Create a copy of RosterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RosterRequestImplCopyWith<_$RosterRequestImpl> get copyWith =>
      __$$RosterRequestImplCopyWithImpl<_$RosterRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RosterRequestImplToJson(
      this,
    );
  }
}

abstract class _RosterRequest implements RosterRequest {
  const factory _RosterRequest(
          {required final String id,
          @JsonKey(name: 'employee_id') required final String employeeId,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'request_type') final String requestType,
          @JsonKey(name: 'current_date') final String? currentDate,
          @JsonKey(name: 'requested_date') final String? requestedDate,
          @JsonKey(name: 'current_route_id') final String? currentRouteId,
          @JsonKey(name: 'requested_route_id') final String? requestedRouteId,
          @JsonKey(name: 'current_stop_id') final String? currentStopId,
          @JsonKey(name: 'requested_stop_id') final String? requestedStopId,
          final String? reason,
          final String status,
          @JsonKey(name: 'rejection_reason') final String? rejectionReason,
          @JsonKey(name: 'approved_by') final String? approvedBy,
          @JsonKey(name: 'approved_at') final String? approvedAt,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$RosterRequestImpl;

  factory _RosterRequest.fromJson(Map<String, dynamic> json) =
      _$RosterRequestImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'employee_id')
  String get employeeId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'request_type')
  String get requestType;
  @override
  @JsonKey(name: 'current_date')
  String? get currentDate;
  @override
  @JsonKey(name: 'requested_date')
  String? get requestedDate;
  @override
  @JsonKey(name: 'current_route_id')
  String? get currentRouteId;
  @override
  @JsonKey(name: 'requested_route_id')
  String? get requestedRouteId;
  @override
  @JsonKey(name: 'current_stop_id')
  String? get currentStopId;
  @override
  @JsonKey(name: 'requested_stop_id')
  String? get requestedStopId;
  @override
  String? get reason;
  @override
  String get status;
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  String? get approvedAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of RosterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RosterRequestImplCopyWith<_$RosterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
