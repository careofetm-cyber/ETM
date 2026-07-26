// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Attendance _$AttendanceFromJson(Map<String, dynamic> json) {
  return _Attendance.fromJson(json);
}

/// @nodoc
mixin _$Attendance {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  AttendanceStatus get status => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  String? get vehicleId => throw _privateConstructorUsedError;
  BoardingMethod? get boardingMethod => throw _privateConstructorUsedError;
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  String? get checkInLocation => throw _privateConstructorUsedError;
  String? get checkOutLocation => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Attendance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Attendance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceCopyWith<Attendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceCopyWith<$Res> {
  factory $AttendanceCopyWith(
          Attendance value, $Res Function(Attendance) then) =
      _$AttendanceCopyWithImpl<$Res, Attendance>;
  @useResult
  $Res call(
      {String id,
      String employeeId,
      DateTime date,
      AttendanceStatus status,
      String? tripId,
      String? vehicleId,
      BoardingMethod? boardingMethod,
      DateTime? checkInTime,
      DateTime? checkOutTime,
      String? checkInLocation,
      String? checkOutLocation,
      String? companyId,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AttendanceCopyWithImpl<$Res, $Val extends Attendance>
    implements $AttendanceCopyWith<$Res> {
  _$AttendanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attendance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? date = null,
    Object? status = null,
    Object? tripId = freezed,
    Object? vehicleId = freezed,
    Object? boardingMethod = freezed,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? checkInLocation = freezed,
    Object? checkOutLocation = freezed,
    Object? companyId = freezed,
    Object? notes = freezed,
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
      boardingMethod: freezed == boardingMethod
          ? _value.boardingMethod
          : boardingMethod // ignore: cast_nullable_to_non_nullable
              as BoardingMethod?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInLocation: freezed == checkInLocation
          ? _value.checkInLocation
          : checkInLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      checkOutLocation: freezed == checkOutLocation
          ? _value.checkOutLocation
          : checkOutLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceImplCopyWith<$Res>
    implements $AttendanceCopyWith<$Res> {
  factory _$$AttendanceImplCopyWith(
          _$AttendanceImpl value, $Res Function(_$AttendanceImpl) then) =
      __$$AttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String employeeId,
      DateTime date,
      AttendanceStatus status,
      String? tripId,
      String? vehicleId,
      BoardingMethod? boardingMethod,
      DateTime? checkInTime,
      DateTime? checkOutTime,
      String? checkInLocation,
      String? checkOutLocation,
      String? companyId,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$AttendanceImplCopyWithImpl<$Res>
    extends _$AttendanceCopyWithImpl<$Res, _$AttendanceImpl>
    implements _$$AttendanceImplCopyWith<$Res> {
  __$$AttendanceImplCopyWithImpl(
      _$AttendanceImpl _value, $Res Function(_$AttendanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Attendance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? date = null,
    Object? status = null,
    Object? tripId = freezed,
    Object? vehicleId = freezed,
    Object? boardingMethod = freezed,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? checkInLocation = freezed,
    Object? checkOutLocation = freezed,
    Object? companyId = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AttendanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
      boardingMethod: freezed == boardingMethod
          ? _value.boardingMethod
          : boardingMethod // ignore: cast_nullable_to_non_nullable
              as BoardingMethod?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInLocation: freezed == checkInLocation
          ? _value.checkInLocation
          : checkInLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      checkOutLocation: freezed == checkOutLocation
          ? _value.checkOutLocation
          : checkOutLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceImpl extends _Attendance {
  const _$AttendanceImpl(
      {required this.id,
      required this.employeeId,
      required this.date,
      required this.status,
      this.tripId,
      this.vehicleId,
      this.boardingMethod,
      this.checkInTime,
      this.checkOutTime,
      this.checkInLocation,
      this.checkOutLocation,
      this.companyId,
      this.notes,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$AttendanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final DateTime date;
  @override
  final AttendanceStatus status;
  @override
  final String? tripId;
  @override
  final String? vehicleId;
  @override
  final BoardingMethod? boardingMethod;
  @override
  final DateTime? checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final String? checkInLocation;
  @override
  final String? checkOutLocation;
  @override
  final String? companyId;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Attendance(id: $id, employeeId: $employeeId, date: $date, status: $status, tripId: $tripId, vehicleId: $vehicleId, boardingMethod: $boardingMethod, checkInTime: $checkInTime, checkOutTime: $checkOutTime, checkInLocation: $checkInLocation, checkOutLocation: $checkOutLocation, companyId: $companyId, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.boardingMethod, boardingMethod) ||
                other.boardingMethod == boardingMethod) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.checkInLocation, checkInLocation) ||
                other.checkInLocation == checkInLocation) &&
            (identical(other.checkOutLocation, checkOutLocation) ||
                other.checkOutLocation == checkOutLocation) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      date,
      status,
      tripId,
      vehicleId,
      boardingMethod,
      checkInTime,
      checkOutTime,
      checkInLocation,
      checkOutLocation,
      companyId,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of Attendance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceImplCopyWith<_$AttendanceImpl> get copyWith =>
      __$$AttendanceImplCopyWithImpl<_$AttendanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceImplToJson(
      this,
    );
  }
}

abstract class _Attendance extends Attendance {
  const factory _Attendance(
      {required final String id,
      required final String employeeId,
      required final DateTime date,
      required final AttendanceStatus status,
      final String? tripId,
      final String? vehicleId,
      final BoardingMethod? boardingMethod,
      final DateTime? checkInTime,
      final DateTime? checkOutTime,
      final String? checkInLocation,
      final String? checkOutLocation,
      final String? companyId,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$AttendanceImpl;
  const _Attendance._() : super._();

  factory _Attendance.fromJson(Map<String, dynamic> json) =
      _$AttendanceImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  DateTime get date;
  @override
  AttendanceStatus get status;
  @override
  String? get tripId;
  @override
  String? get vehicleId;
  @override
  BoardingMethod? get boardingMethod;
  @override
  DateTime? get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  String? get checkInLocation;
  @override
  String? get checkOutLocation;
  @override
  String? get companyId;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Attendance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceImplCopyWith<_$AttendanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransportRequest _$TransportRequestFromJson(Map<String, dynamic> json) {
  return _TransportRequest.fromJson(json);
}

/// @nodoc
mixin _$TransportRequest {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  TransportRequestType get type => throw _privateConstructorUsedError;
  TransportRequestStatus get status => throw _privateConstructorUsedError;
  String? get routeId => throw _privateConstructorUsedError;
  String? get stopId => throw _privateConstructorUsedError;
  DateTime? get effectiveFrom => throw _privateConstructorUsedError;
  DateTime? get effectiveTo => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TransportRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransportRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransportRequestCopyWith<TransportRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportRequestCopyWith<$Res> {
  factory $TransportRequestCopyWith(
          TransportRequest value, $Res Function(TransportRequest) then) =
      _$TransportRequestCopyWithImpl<$Res, TransportRequest>;
  @useResult
  $Res call(
      {String id,
      String employeeId,
      String companyId,
      TransportRequestType type,
      TransportRequestStatus status,
      String? routeId,
      String? stopId,
      DateTime? effectiveFrom,
      DateTime? effectiveTo,
      String? reason,
      String? rejectionReason,
      String? approvedBy,
      DateTime? approvedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$TransportRequestCopyWithImpl<$Res, $Val extends TransportRequest>
    implements $TransportRequestCopyWith<$Res> {
  _$TransportRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransportRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? type = null,
    Object? status = null,
    Object? routeId = freezed,
    Object? stopId = freezed,
    Object? effectiveFrom = freezed,
    Object? effectiveTo = freezed,
    Object? reason = freezed,
    Object? rejectionReason = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransportRequestType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransportRequestStatus,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      stopId: freezed == stopId
          ? _value.stopId
          : stopId // ignore: cast_nullable_to_non_nullable
              as String?,
      effectiveFrom: freezed == effectiveFrom
          ? _value.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      effectiveTo: freezed == effectiveTo
          ? _value.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransportRequestImplCopyWith<$Res>
    implements $TransportRequestCopyWith<$Res> {
  factory _$$TransportRequestImplCopyWith(_$TransportRequestImpl value,
          $Res Function(_$TransportRequestImpl) then) =
      __$$TransportRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String employeeId,
      String companyId,
      TransportRequestType type,
      TransportRequestStatus status,
      String? routeId,
      String? stopId,
      DateTime? effectiveFrom,
      DateTime? effectiveTo,
      String? reason,
      String? rejectionReason,
      String? approvedBy,
      DateTime? approvedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$TransportRequestImplCopyWithImpl<$Res>
    extends _$TransportRequestCopyWithImpl<$Res, _$TransportRequestImpl>
    implements _$$TransportRequestImplCopyWith<$Res> {
  __$$TransportRequestImplCopyWithImpl(_$TransportRequestImpl _value,
      $Res Function(_$TransportRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransportRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? type = null,
    Object? status = null,
    Object? routeId = freezed,
    Object? stopId = freezed,
    Object? effectiveFrom = freezed,
    Object? effectiveTo = freezed,
    Object? reason = freezed,
    Object? rejectionReason = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TransportRequestImpl(
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransportRequestType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransportRequestStatus,
      routeId: freezed == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String?,
      stopId: freezed == stopId
          ? _value.stopId
          : stopId // ignore: cast_nullable_to_non_nullable
              as String?,
      effectiveFrom: freezed == effectiveFrom
          ? _value.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      effectiveTo: freezed == effectiveTo
          ? _value.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportRequestImpl implements _TransportRequest {
  const _$TransportRequestImpl(
      {required this.id,
      required this.employeeId,
      required this.companyId,
      required this.type,
      required this.status,
      this.routeId,
      this.stopId,
      this.effectiveFrom,
      this.effectiveTo,
      this.reason,
      this.rejectionReason,
      this.approvedBy,
      this.approvedAt,
      this.createdAt,
      this.updatedAt});

  factory _$TransportRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String companyId;
  @override
  final TransportRequestType type;
  @override
  final TransportRequestStatus status;
  @override
  final String? routeId;
  @override
  final String? stopId;
  @override
  final DateTime? effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final String? reason;
  @override
  final String? rejectionReason;
  @override
  final String? approvedBy;
  @override
  final DateTime? approvedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TransportRequest(id: $id, employeeId: $employeeId, companyId: $companyId, type: $type, status: $status, routeId: $routeId, stopId: $stopId, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, reason: $reason, rejectionReason: $rejectionReason, approvedBy: $approvedBy, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.stopId, stopId) || other.stopId == stopId) &&
            (identical(other.effectiveFrom, effectiveFrom) ||
                other.effectiveFrom == effectiveFrom) &&
            (identical(other.effectiveTo, effectiveTo) ||
                other.effectiveTo == effectiveTo) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      companyId,
      type,
      status,
      routeId,
      stopId,
      effectiveFrom,
      effectiveTo,
      reason,
      rejectionReason,
      approvedBy,
      approvedAt,
      createdAt,
      updatedAt);

  /// Create a copy of TransportRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportRequestImplCopyWith<_$TransportRequestImpl> get copyWith =>
      __$$TransportRequestImplCopyWithImpl<_$TransportRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportRequestImplToJson(
      this,
    );
  }
}

abstract class _TransportRequest implements TransportRequest {
  const factory _TransportRequest(
      {required final String id,
      required final String employeeId,
      required final String companyId,
      required final TransportRequestType type,
      required final TransportRequestStatus status,
      final String? routeId,
      final String? stopId,
      final DateTime? effectiveFrom,
      final DateTime? effectiveTo,
      final String? reason,
      final String? rejectionReason,
      final String? approvedBy,
      final DateTime? approvedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$TransportRequestImpl;

  factory _TransportRequest.fromJson(Map<String, dynamic> json) =
      _$TransportRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId;
  @override
  String get companyId;
  @override
  TransportRequestType get type;
  @override
  TransportRequestStatus get status;
  @override
  String? get routeId;
  @override
  String? get stopId;
  @override
  DateTime? get effectiveFrom;
  @override
  DateTime? get effectiveTo;
  @override
  String? get reason;
  @override
  String? get rejectionReason;
  @override
  String? get approvedBy;
  @override
  DateTime? get approvedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of TransportRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportRequestImplCopyWith<_$TransportRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
