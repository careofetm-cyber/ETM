// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  String get routeId => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  TripType get type => throw _privateConstructorUsedError;
  TripStatus get status => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  DateTime? get actualStartTime => throw _privateConstructorUsedError;
  DateTime? get actualEndTime => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  int? get totalPassengers => throw _privateConstructorUsedError;
  int? get boardedPassengers => throw _privateConstructorUsedError;
  double? get totalDistance => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call(
      {String id,
      String routeId,
      String vehicleId,
      String driverId,
      TripType type,
      TripStatus status,
      DateTime scheduledTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      String? companyId,
      int? totalPassengers,
      int? boardedPassengers,
      double? totalDistance,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? vehicleId = null,
    Object? driverId = null,
    Object? type = null,
    Object? status = null,
    Object? scheduledTime = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? companyId = freezed,
    Object? totalPassengers = freezed,
    Object? boardedPassengers = freezed,
    Object? totalDistance = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: null == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPassengers: freezed == totalPassengers
          ? _value.totalPassengers
          : totalPassengers // ignore: cast_nullable_to_non_nullable
              as int?,
      boardedPassengers: freezed == boardedPassengers
          ? _value.boardedPassengers
          : boardedPassengers // ignore: cast_nullable_to_non_nullable
              as int?,
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double?,
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
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
          _$TripImpl value, $Res Function(_$TripImpl) then) =
      __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String routeId,
      String vehicleId,
      String driverId,
      TripType type,
      TripStatus status,
      DateTime scheduledTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      String? companyId,
      int? totalPassengers,
      int? boardedPassengers,
      double? totalDistance,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
      : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? vehicleId = null,
    Object? driverId = null,
    Object? type = null,
    Object? status = null,
    Object? scheduledTime = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? companyId = freezed,
    Object? totalPassengers = freezed,
    Object? boardedPassengers = freezed,
    Object? totalDistance = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TripImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: null == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TripType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPassengers: freezed == totalPassengers
          ? _value.totalPassengers
          : totalPassengers // ignore: cast_nullable_to_non_nullable
              as int?,
      boardedPassengers: freezed == boardedPassengers
          ? _value.boardedPassengers
          : boardedPassengers // ignore: cast_nullable_to_non_nullable
              as int?,
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double?,
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
class _$TripImpl extends _Trip {
  const _$TripImpl(
      {required this.id,
      required this.routeId,
      required this.vehicleId,
      required this.driverId,
      required this.type,
      required this.status,
      required this.scheduledTime,
      this.actualStartTime,
      this.actualEndTime,
      this.companyId,
      this.totalPassengers,
      this.boardedPassengers,
      this.totalDistance,
      this.notes,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  final String id;
  @override
  final String routeId;
  @override
  final String vehicleId;
  @override
  final String driverId;
  @override
  final TripType type;
  @override
  final TripStatus status;
  @override
  final DateTime scheduledTime;
  @override
  final DateTime? actualStartTime;
  @override
  final DateTime? actualEndTime;
  @override
  final String? companyId;
  @override
  final int? totalPassengers;
  @override
  final int? boardedPassengers;
  @override
  final double? totalDistance;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Trip(id: $id, routeId: $routeId, vehicleId: $vehicleId, driverId: $driverId, type: $type, status: $status, scheduledTime: $scheduledTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, companyId: $companyId, totalPassengers: $totalPassengers, boardedPassengers: $boardedPassengers, totalDistance: $totalDistance, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.totalPassengers, totalPassengers) ||
                other.totalPassengers == totalPassengers) &&
            (identical(other.boardedPassengers, boardedPassengers) ||
                other.boardedPassengers == boardedPassengers) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
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
      routeId,
      vehicleId,
      driverId,
      type,
      status,
      scheduledTime,
      actualStartTime,
      actualEndTime,
      companyId,
      totalPassengers,
      boardedPassengers,
      totalDistance,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(
      this,
    );
  }
}

abstract class _Trip extends Trip {
  const factory _Trip(
      {required final String id,
      required final String routeId,
      required final String vehicleId,
      required final String driverId,
      required final TripType type,
      required final TripStatus status,
      required final DateTime scheduledTime,
      final DateTime? actualStartTime,
      final DateTime? actualEndTime,
      final String? companyId,
      final int? totalPassengers,
      final int? boardedPassengers,
      final double? totalDistance,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$TripImpl;
  const _Trip._() : super._();

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  String get id;
  @override
  String get routeId;
  @override
  String get vehicleId;
  @override
  String get driverId;
  @override
  TripType get type;
  @override
  TripStatus get status;
  @override
  DateTime get scheduledTime;
  @override
  DateTime? get actualStartTime;
  @override
  DateTime? get actualEndTime;
  @override
  String? get companyId;
  @override
  int? get totalPassengers;
  @override
  int? get boardedPassengers;
  @override
  double? get totalDistance;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripPassenger _$TripPassengerFromJson(Map<String, dynamic> json) {
  return _TripPassenger.fromJson(json);
}

/// @nodoc
mixin _$TripPassenger {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String get stopId => throw _privateConstructorUsedError;
  bool? get isBoarded => throw _privateConstructorUsedError;
  bool? get isDropped => throw _privateConstructorUsedError;
  DateTime? get boardedAt => throw _privateConstructorUsedError;
  DateTime? get droppedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TripPassenger to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripPassengerCopyWith<TripPassenger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripPassengerCopyWith<$Res> {
  factory $TripPassengerCopyWith(
          TripPassenger value, $Res Function(TripPassenger) then) =
      _$TripPassengerCopyWithImpl<$Res, TripPassenger>;
  @useResult
  $Res call(
      {String id,
      String tripId,
      String employeeId,
      String stopId,
      bool? isBoarded,
      bool? isDropped,
      DateTime? boardedAt,
      DateTime? droppedAt,
      DateTime? createdAt});
}

/// @nodoc
class _$TripPassengerCopyWithImpl<$Res, $Val extends TripPassenger>
    implements $TripPassengerCopyWith<$Res> {
  _$TripPassengerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? employeeId = null,
    Object? stopId = null,
    Object? isBoarded = freezed,
    Object? isDropped = freezed,
    Object? boardedAt = freezed,
    Object? droppedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      stopId: null == stopId
          ? _value.stopId
          : stopId // ignore: cast_nullable_to_non_nullable
              as String,
      isBoarded: freezed == isBoarded
          ? _value.isBoarded
          : isBoarded // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDropped: freezed == isDropped
          ? _value.isDropped
          : isDropped // ignore: cast_nullable_to_non_nullable
              as bool?,
      boardedAt: freezed == boardedAt
          ? _value.boardedAt
          : boardedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      droppedAt: freezed == droppedAt
          ? _value.droppedAt
          : droppedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripPassengerImplCopyWith<$Res>
    implements $TripPassengerCopyWith<$Res> {
  factory _$$TripPassengerImplCopyWith(
          _$TripPassengerImpl value, $Res Function(_$TripPassengerImpl) then) =
      __$$TripPassengerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tripId,
      String employeeId,
      String stopId,
      bool? isBoarded,
      bool? isDropped,
      DateTime? boardedAt,
      DateTime? droppedAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$TripPassengerImplCopyWithImpl<$Res>
    extends _$TripPassengerCopyWithImpl<$Res, _$TripPassengerImpl>
    implements _$$TripPassengerImplCopyWith<$Res> {
  __$$TripPassengerImplCopyWithImpl(
      _$TripPassengerImpl _value, $Res Function(_$TripPassengerImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? employeeId = null,
    Object? stopId = null,
    Object? isBoarded = freezed,
    Object? isDropped = freezed,
    Object? boardedAt = freezed,
    Object? droppedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TripPassengerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      stopId: null == stopId
          ? _value.stopId
          : stopId // ignore: cast_nullable_to_non_nullable
              as String,
      isBoarded: freezed == isBoarded
          ? _value.isBoarded
          : isBoarded // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDropped: freezed == isDropped
          ? _value.isDropped
          : isDropped // ignore: cast_nullable_to_non_nullable
              as bool?,
      boardedAt: freezed == boardedAt
          ? _value.boardedAt
          : boardedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      droppedAt: freezed == droppedAt
          ? _value.droppedAt
          : droppedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripPassengerImpl implements _TripPassenger {
  const _$TripPassengerImpl(
      {required this.id,
      required this.tripId,
      required this.employeeId,
      required this.stopId,
      this.isBoarded,
      this.isDropped,
      this.boardedAt,
      this.droppedAt,
      this.createdAt});

  factory _$TripPassengerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripPassengerImplFromJson(json);

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String employeeId;
  @override
  final String stopId;
  @override
  final bool? isBoarded;
  @override
  final bool? isDropped;
  @override
  final DateTime? boardedAt;
  @override
  final DateTime? droppedAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TripPassenger(id: $id, tripId: $tripId, employeeId: $employeeId, stopId: $stopId, isBoarded: $isBoarded, isDropped: $isDropped, boardedAt: $boardedAt, droppedAt: $droppedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripPassengerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.stopId, stopId) || other.stopId == stopId) &&
            (identical(other.isBoarded, isBoarded) ||
                other.isBoarded == isBoarded) &&
            (identical(other.isDropped, isDropped) ||
                other.isDropped == isDropped) &&
            (identical(other.boardedAt, boardedAt) ||
                other.boardedAt == boardedAt) &&
            (identical(other.droppedAt, droppedAt) ||
                other.droppedAt == droppedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tripId, employeeId, stopId,
      isBoarded, isDropped, boardedAt, droppedAt, createdAt);

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripPassengerImplCopyWith<_$TripPassengerImpl> get copyWith =>
      __$$TripPassengerImplCopyWithImpl<_$TripPassengerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripPassengerImplToJson(
      this,
    );
  }
}

abstract class _TripPassenger implements TripPassenger {
  const factory _TripPassenger(
      {required final String id,
      required final String tripId,
      required final String employeeId,
      required final String stopId,
      final bool? isBoarded,
      final bool? isDropped,
      final DateTime? boardedAt,
      final DateTime? droppedAt,
      final DateTime? createdAt}) = _$TripPassengerImpl;

  factory _TripPassenger.fromJson(Map<String, dynamic> json) =
      _$TripPassengerImpl.fromJson;

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get employeeId;
  @override
  String get stopId;
  @override
  bool? get isBoarded;
  @override
  bool? get isDropped;
  @override
  DateTime? get boardedAt;
  @override
  DateTime? get droppedAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripPassengerImplCopyWith<_$TripPassengerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GPSLog _$GPSLogFromJson(Map<String, dynamic> json) {
  return _GPSLog.fromJson(json);
}

/// @nodoc
mixin _$GPSLog {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get heading => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this GPSLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GPSLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GPSLogCopyWith<GPSLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GPSLogCopyWith<$Res> {
  factory $GPSLogCopyWith(GPSLog value, $Res Function(GPSLog) then) =
      _$GPSLogCopyWithImpl<$Res, GPSLog>;
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String? tripId,
      double latitude,
      double longitude,
      double? speed,
      double? heading,
      double? altitude,
      DateTime timestamp});
}

/// @nodoc
class _$GPSLogCopyWithImpl<$Res, $Val extends GPSLog>
    implements $GPSLogCopyWith<$Res> {
  _$GPSLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GPSLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? tripId = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? altitude = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      heading: freezed == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double?,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GPSLogImplCopyWith<$Res> implements $GPSLogCopyWith<$Res> {
  factory _$$GPSLogImplCopyWith(
          _$GPSLogImpl value, $Res Function(_$GPSLogImpl) then) =
      __$$GPSLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String? tripId,
      double latitude,
      double longitude,
      double? speed,
      double? heading,
      double? altitude,
      DateTime timestamp});
}

/// @nodoc
class __$$GPSLogImplCopyWithImpl<$Res>
    extends _$GPSLogCopyWithImpl<$Res, _$GPSLogImpl>
    implements _$$GPSLogImplCopyWith<$Res> {
  __$$GPSLogImplCopyWithImpl(
      _$GPSLogImpl _value, $Res Function(_$GPSLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of GPSLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? tripId = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? altitude = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$GPSLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      heading: freezed == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double?,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GPSLogImpl implements _GPSLog {
  const _$GPSLogImpl(
      {required this.id,
      required this.vehicleId,
      this.tripId,
      required this.latitude,
      required this.longitude,
      this.speed,
      this.heading,
      this.altitude,
      required this.timestamp});

  factory _$GPSLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$GPSLogImplFromJson(json);

  @override
  final String id;
  @override
  final String vehicleId;
  @override
  final String? tripId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? speed;
  @override
  final double? heading;
  @override
  final double? altitude;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'GPSLog(id: $id, vehicleId: $vehicleId, tripId: $tripId, latitude: $latitude, longitude: $longitude, speed: $speed, heading: $heading, altitude: $altitude, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GPSLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, vehicleId, tripId, latitude,
      longitude, speed, heading, altitude, timestamp);

  /// Create a copy of GPSLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GPSLogImplCopyWith<_$GPSLogImpl> get copyWith =>
      __$$GPSLogImplCopyWithImpl<_$GPSLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GPSLogImplToJson(
      this,
    );
  }
}

abstract class _GPSLog implements GPSLog {
  const factory _GPSLog(
      {required final String id,
      required final String vehicleId,
      final String? tripId,
      required final double latitude,
      required final double longitude,
      final double? speed,
      final double? heading,
      final double? altitude,
      required final DateTime timestamp}) = _$GPSLogImpl;

  factory _GPSLog.fromJson(Map<String, dynamic> json) = _$GPSLogImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  String? get tripId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get speed;
  @override
  double? get heading;
  @override
  double? get altitude;
  @override
  DateTime get timestamp;

  /// Create a copy of GPSLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GPSLogImplCopyWith<_$GPSLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationUpdate _$LocationUpdateFromJson(Map<String, dynamic> json) {
  return _LocationUpdate.fromJson(json);
}

/// @nodoc
mixin _$LocationUpdate {
  String get vehicleId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get heading => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this LocationUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationUpdateCopyWith<LocationUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationUpdateCopyWith<$Res> {
  factory $LocationUpdateCopyWith(
          LocationUpdate value, $Res Function(LocationUpdate) then) =
      _$LocationUpdateCopyWithImpl<$Res, LocationUpdate>;
  @useResult
  $Res call(
      {String vehicleId,
      double latitude,
      double longitude,
      double? speed,
      double? heading,
      DateTime? timestamp});
}

/// @nodoc
class _$LocationUpdateCopyWithImpl<$Res, $Val extends LocationUpdate>
    implements $LocationUpdateCopyWith<$Res> {
  _$LocationUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      heading: freezed == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationUpdateImplCopyWith<$Res>
    implements $LocationUpdateCopyWith<$Res> {
  factory _$$LocationUpdateImplCopyWith(_$LocationUpdateImpl value,
          $Res Function(_$LocationUpdateImpl) then) =
      __$$LocationUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String vehicleId,
      double latitude,
      double longitude,
      double? speed,
      double? heading,
      DateTime? timestamp});
}

/// @nodoc
class __$$LocationUpdateImplCopyWithImpl<$Res>
    extends _$LocationUpdateCopyWithImpl<$Res, _$LocationUpdateImpl>
    implements _$$LocationUpdateImplCopyWith<$Res> {
  __$$LocationUpdateImplCopyWithImpl(
      _$LocationUpdateImpl _value, $Res Function(_$LocationUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$LocationUpdateImpl(
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      heading: freezed == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationUpdateImpl implements _LocationUpdate {
  const _$LocationUpdateImpl(
      {required this.vehicleId,
      required this.latitude,
      required this.longitude,
      this.speed,
      this.heading,
      this.timestamp});

  factory _$LocationUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationUpdateImplFromJson(json);

  @override
  final String vehicleId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? speed;
  @override
  final double? heading;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'LocationUpdate(vehicleId: $vehicleId, latitude: $latitude, longitude: $longitude, speed: $speed, heading: $heading, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationUpdateImpl &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, vehicleId, latitude, longitude, speed, heading, timestamp);

  /// Create a copy of LocationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationUpdateImplCopyWith<_$LocationUpdateImpl> get copyWith =>
      __$$LocationUpdateImplCopyWithImpl<_$LocationUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationUpdateImplToJson(
      this,
    );
  }
}

abstract class _LocationUpdate implements LocationUpdate {
  const factory _LocationUpdate(
      {required final String vehicleId,
      required final double latitude,
      required final double longitude,
      final double? speed,
      final double? heading,
      final DateTime? timestamp}) = _$LocationUpdateImpl;

  factory _LocationUpdate.fromJson(Map<String, dynamic> json) =
      _$LocationUpdateImpl.fromJson;

  @override
  String get vehicleId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get speed;
  @override
  double? get heading;
  @override
  DateTime? get timestamp;

  /// Create a copy of LocationUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationUpdateImplCopyWith<_$LocationUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
