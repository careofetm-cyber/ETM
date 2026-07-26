// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incident.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Incident _$IncidentFromJson(Map<String, dynamic> json) {
  return _Incident.fromJson(json);
}

/// @nodoc
mixin _$Incident {
  String get id => throw _privateConstructorUsedError;
  String get reportedBy => throw _privateConstructorUsedError;
  String? get vehicleId => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  String? get driverId => throw _privateConstructorUsedError;
  IncidentSeverity get severity => throw _privateConstructorUsedError;
  IncidentStatus get status => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  DateTime? get incidentTime => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  String? get resolution => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Incident to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncidentCopyWith<Incident> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncidentCopyWith<$Res> {
  factory $IncidentCopyWith(Incident value, $Res Function(Incident) then) =
      _$IncidentCopyWithImpl<$Res, Incident>;
  @useResult
  $Res call(
      {String id,
      String reportedBy,
      String? vehicleId,
      String? tripId,
      String? driverId,
      IncidentSeverity severity,
      IncidentStatus status,
      String description,
      String? location,
      double? latitude,
      double? longitude,
      DateTime? incidentTime,
      List<String>? imageUrls,
      String? resolution,
      String? resolvedBy,
      DateTime? resolvedAt,
      String? companyId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$IncidentCopyWithImpl<$Res, $Val extends Incident>
    implements $IncidentCopyWith<$Res> {
  _$IncidentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportedBy = null,
    Object? vehicleId = freezed,
    Object? tripId = freezed,
    Object? driverId = freezed,
    Object? severity = null,
    Object? status = null,
    Object? description = null,
    Object? location = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? incidentTime = freezed,
    Object? imageUrls = freezed,
    Object? resolution = freezed,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reportedBy: null == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as IncidentSeverity,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as IncidentStatus,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      incidentTime: freezed == incidentTime
          ? _value.incidentTime
          : incidentTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      resolution: freezed == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$IncidentImplCopyWith<$Res>
    implements $IncidentCopyWith<$Res> {
  factory _$$IncidentImplCopyWith(
          _$IncidentImpl value, $Res Function(_$IncidentImpl) then) =
      __$$IncidentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reportedBy,
      String? vehicleId,
      String? tripId,
      String? driverId,
      IncidentSeverity severity,
      IncidentStatus status,
      String description,
      String? location,
      double? latitude,
      double? longitude,
      DateTime? incidentTime,
      List<String>? imageUrls,
      String? resolution,
      String? resolvedBy,
      DateTime? resolvedAt,
      String? companyId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$IncidentImplCopyWithImpl<$Res>
    extends _$IncidentCopyWithImpl<$Res, _$IncidentImpl>
    implements _$$IncidentImplCopyWith<$Res> {
  __$$IncidentImplCopyWithImpl(
      _$IncidentImpl _value, $Res Function(_$IncidentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportedBy = null,
    Object? vehicleId = freezed,
    Object? tripId = freezed,
    Object? driverId = freezed,
    Object? severity = null,
    Object? status = null,
    Object? description = null,
    Object? location = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? incidentTime = freezed,
    Object? imageUrls = freezed,
    Object? resolution = freezed,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$IncidentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reportedBy: null == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
      tripId: freezed == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as IncidentSeverity,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as IncidentStatus,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      incidentTime: freezed == incidentTime
          ? _value.incidentTime
          : incidentTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      resolution: freezed == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
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
class _$IncidentImpl implements _Incident {
  const _$IncidentImpl(
      {required this.id,
      required this.reportedBy,
      required this.vehicleId,
      required this.tripId,
      required this.driverId,
      required this.severity,
      required this.status,
      required this.description,
      this.location,
      this.latitude,
      this.longitude,
      this.incidentTime,
      final List<String>? imageUrls,
      this.resolution,
      this.resolvedBy,
      this.resolvedAt,
      this.companyId,
      this.createdAt,
      this.updatedAt})
      : _imageUrls = imageUrls;

  factory _$IncidentImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncidentImplFromJson(json);

  @override
  final String id;
  @override
  final String reportedBy;
  @override
  final String? vehicleId;
  @override
  final String? tripId;
  @override
  final String? driverId;
  @override
  final IncidentSeverity severity;
  @override
  final IncidentStatus status;
  @override
  final String description;
  @override
  final String? location;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final DateTime? incidentTime;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? resolution;
  @override
  final String? resolvedBy;
  @override
  final DateTime? resolvedAt;
  @override
  final String? companyId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Incident(id: $id, reportedBy: $reportedBy, vehicleId: $vehicleId, tripId: $tripId, driverId: $driverId, severity: $severity, status: $status, description: $description, location: $location, latitude: $latitude, longitude: $longitude, incidentTime: $incidentTime, imageUrls: $imageUrls, resolution: $resolution, resolvedBy: $resolvedBy, resolvedAt: $resolvedAt, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncidentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.incidentTime, incidentTime) ||
                other.incidentTime == incidentTime) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        reportedBy,
        vehicleId,
        tripId,
        driverId,
        severity,
        status,
        description,
        location,
        latitude,
        longitude,
        incidentTime,
        const DeepCollectionEquality().hash(_imageUrls),
        resolution,
        resolvedBy,
        resolvedAt,
        companyId,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncidentImplCopyWith<_$IncidentImpl> get copyWith =>
      __$$IncidentImplCopyWithImpl<_$IncidentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncidentImplToJson(
      this,
    );
  }
}

abstract class _Incident implements Incident {
  const factory _Incident(
      {required final String id,
      required final String reportedBy,
      required final String? vehicleId,
      required final String? tripId,
      required final String? driverId,
      required final IncidentSeverity severity,
      required final IncidentStatus status,
      required final String description,
      final String? location,
      final double? latitude,
      final double? longitude,
      final DateTime? incidentTime,
      final List<String>? imageUrls,
      final String? resolution,
      final String? resolvedBy,
      final DateTime? resolvedAt,
      final String? companyId,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$IncidentImpl;

  factory _Incident.fromJson(Map<String, dynamic> json) =
      _$IncidentImpl.fromJson;

  @override
  String get id;
  @override
  String get reportedBy;
  @override
  String? get vehicleId;
  @override
  String? get tripId;
  @override
  String? get driverId;
  @override
  IncidentSeverity get severity;
  @override
  IncidentStatus get status;
  @override
  String get description;
  @override
  String? get location;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  DateTime? get incidentTime;
  @override
  List<String>? get imageUrls;
  @override
  String? get resolution;
  @override
  String? get resolvedBy;
  @override
  DateTime? get resolvedAt;
  @override
  String? get companyId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncidentImplCopyWith<_$IncidentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SOSAlert _$SOSAlertFromJson(Map<String, dynamic> json) {
  return _SOSAlert.fromJson(json);
}

/// @nodoc
mixin _$SOSAlert {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userType => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SOSAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SOSAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SOSAlertCopyWith<SOSAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SOSAlertCopyWith<$Res> {
  factory $SOSAlertCopyWith(SOSAlert value, $Res Function(SOSAlert) then) =
      _$SOSAlertCopyWithImpl<$Res, SOSAlert>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userType,
      double latitude,
      double longitude,
      String? message,
      bool isResolved,
      String? resolvedBy,
      DateTime? resolvedAt,
      String? companyId,
      DateTime? createdAt});
}

/// @nodoc
class _$SOSAlertCopyWithImpl<$Res, $Val extends SOSAlert>
    implements $SOSAlertCopyWith<$Res> {
  _$SOSAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SOSAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userType = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? message = freezed,
    Object? isResolved = null,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SOSAlertImplCopyWith<$Res>
    implements $SOSAlertCopyWith<$Res> {
  factory _$$SOSAlertImplCopyWith(
          _$SOSAlertImpl value, $Res Function(_$SOSAlertImpl) then) =
      __$$SOSAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userType,
      double latitude,
      double longitude,
      String? message,
      bool isResolved,
      String? resolvedBy,
      DateTime? resolvedAt,
      String? companyId,
      DateTime? createdAt});
}

/// @nodoc
class __$$SOSAlertImplCopyWithImpl<$Res>
    extends _$SOSAlertCopyWithImpl<$Res, _$SOSAlertImpl>
    implements _$$SOSAlertImplCopyWith<$Res> {
  __$$SOSAlertImplCopyWithImpl(
      _$SOSAlertImpl _value, $Res Function(_$SOSAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of SOSAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userType = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? message = freezed,
    Object? isResolved = null,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SOSAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SOSAlertImpl implements _SOSAlert {
  const _$SOSAlertImpl(
      {required this.id,
      required this.userId,
      required this.userType,
      required this.latitude,
      required this.longitude,
      this.message,
      required this.isResolved,
      this.resolvedBy,
      this.resolvedAt,
      this.companyId,
      this.createdAt});

  factory _$SOSAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$SOSAlertImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userType;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? message;
  @override
  final bool isResolved;
  @override
  final String? resolvedBy;
  @override
  final DateTime? resolvedAt;
  @override
  final String? companyId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SOSAlert(id: $id, userId: $userId, userType: $userType, latitude: $latitude, longitude: $longitude, message: $message, isResolved: $isResolved, resolvedBy: $resolvedBy, resolvedAt: $resolvedAt, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SOSAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userType,
      latitude,
      longitude,
      message,
      isResolved,
      resolvedBy,
      resolvedAt,
      companyId,
      createdAt);

  /// Create a copy of SOSAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SOSAlertImplCopyWith<_$SOSAlertImpl> get copyWith =>
      __$$SOSAlertImplCopyWithImpl<_$SOSAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SOSAlertImplToJson(
      this,
    );
  }
}

abstract class _SOSAlert implements SOSAlert {
  const factory _SOSAlert(
      {required final String id,
      required final String userId,
      required final String userType,
      required final double latitude,
      required final double longitude,
      final String? message,
      required final bool isResolved,
      final String? resolvedBy,
      final DateTime? resolvedAt,
      final String? companyId,
      final DateTime? createdAt}) = _$SOSAlertImpl;

  factory _SOSAlert.fromJson(Map<String, dynamic> json) =
      _$SOSAlertImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userType;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get message;
  @override
  bool get isResolved;
  @override
  String? get resolvedBy;
  @override
  DateTime? get resolvedAt;
  @override
  String? get companyId;
  @override
  DateTime? get createdAt;

  /// Create a copy of SOSAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SOSAlertImplCopyWith<_$SOSAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
