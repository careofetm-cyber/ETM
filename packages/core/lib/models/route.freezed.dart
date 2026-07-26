// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Route _$RouteFromJson(Map<String, dynamic> json) {
  return _Route.fromJson(json);
}

/// @nodoc
mixin _$Route {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<RouteStop> get stops => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  int get estimatedDuration => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Route to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Route
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteCopyWith<Route> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteCopyWith<$Res> {
  factory $RouteCopyWith(Route value, $Res Function(Route) then) =
      _$RouteCopyWithImpl<$Res, Route>;
  @useResult
  $Res call(
      {String id,
      String name,
      String companyId,
      String? description,
      List<RouteStop> stops,
      double totalDistance,
      int estimatedDuration,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RouteCopyWithImpl<$Res, $Val extends Route>
    implements $RouteCopyWith<$Res> {
  _$RouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Route
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? companyId = null,
    Object? description = freezed,
    Object? stops = null,
    Object? totalDistance = null,
    Object? estimatedDuration = null,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      stops: null == stops
          ? _value.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<RouteStop>,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedDuration: null == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
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
abstract class _$$RouteImplCopyWith<$Res> implements $RouteCopyWith<$Res> {
  factory _$$RouteImplCopyWith(
          _$RouteImpl value, $Res Function(_$RouteImpl) then) =
      __$$RouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String companyId,
      String? description,
      List<RouteStop> stops,
      double totalDistance,
      int estimatedDuration,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RouteImplCopyWithImpl<$Res>
    extends _$RouteCopyWithImpl<$Res, _$RouteImpl>
    implements _$$RouteImplCopyWith<$Res> {
  __$$RouteImplCopyWithImpl(
      _$RouteImpl _value, $Res Function(_$RouteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Route
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? companyId = null,
    Object? description = freezed,
    Object? stops = null,
    Object? totalDistance = null,
    Object? estimatedDuration = null,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RouteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      stops: null == stops
          ? _value._stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<RouteStop>,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedDuration: null == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
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
class _$RouteImpl implements _Route {
  const _$RouteImpl(
      {required this.id,
      required this.name,
      required this.companyId,
      this.description,
      required final List<RouteStop> stops,
      required this.totalDistance,
      required this.estimatedDuration,
      this.isActive,
      this.createdAt,
      this.updatedAt})
      : _stops = stops;

  factory _$RouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String companyId;
  @override
  final String? description;
  final List<RouteStop> _stops;
  @override
  List<RouteStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  @override
  final double totalDistance;
  @override
  final int estimatedDuration;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Route(id: $id, name: $name, companyId: $companyId, description: $description, stops: $stops, totalDistance: $totalDistance, estimatedDuration: $estimatedDuration, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      name,
      companyId,
      description,
      const DeepCollectionEquality().hash(_stops),
      totalDistance,
      estimatedDuration,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of Route
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteImplCopyWith<_$RouteImpl> get copyWith =>
      __$$RouteImplCopyWithImpl<_$RouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteImplToJson(
      this,
    );
  }
}

abstract class _Route implements Route {
  const factory _Route(
      {required final String id,
      required final String name,
      required final String companyId,
      final String? description,
      required final List<RouteStop> stops,
      required final double totalDistance,
      required final int estimatedDuration,
      final bool? isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RouteImpl;

  factory _Route.fromJson(Map<String, dynamic> json) = _$RouteImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get companyId;
  @override
  String? get description;
  @override
  List<RouteStop> get stops;
  @override
  double get totalDistance;
  @override
  int get estimatedDuration;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Route
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteImplCopyWith<_$RouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteStop _$RouteStopFromJson(Map<String, dynamic> json) {
  return _RouteStop.fromJson(json);
}

/// @nodoc
mixin _$RouteStop {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int get sequenceOrder => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get landmark => throw _privateConstructorUsedError;
  int? get estimatedTimeFromPrevious => throw _privateConstructorUsedError;
  double? get distanceFromPrevious => throw _privateConstructorUsedError;

  /// Serializes this RouteStop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteStopCopyWith<RouteStop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteStopCopyWith<$Res> {
  factory $RouteStopCopyWith(RouteStop value, $Res Function(RouteStop) then) =
      _$RouteStopCopyWithImpl<$Res, RouteStop>;
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      int sequenceOrder,
      String? address,
      String? landmark,
      int? estimatedTimeFromPrevious,
      double? distanceFromPrevious});
}

/// @nodoc
class _$RouteStopCopyWithImpl<$Res, $Val extends RouteStop>
    implements $RouteStopCopyWith<$Res> {
  _$RouteStopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? sequenceOrder = null,
    Object? address = freezed,
    Object? landmark = freezed,
    Object? estimatedTimeFromPrevious = freezed,
    Object? distanceFromPrevious = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      sequenceOrder: null == sequenceOrder
          ? _value.sequenceOrder
          : sequenceOrder // ignore: cast_nullable_to_non_nullable
              as int,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedTimeFromPrevious: freezed == estimatedTimeFromPrevious
          ? _value.estimatedTimeFromPrevious
          : estimatedTimeFromPrevious // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceFromPrevious: freezed == distanceFromPrevious
          ? _value.distanceFromPrevious
          : distanceFromPrevious // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteStopImplCopyWith<$Res>
    implements $RouteStopCopyWith<$Res> {
  factory _$$RouteStopImplCopyWith(
          _$RouteStopImpl value, $Res Function(_$RouteStopImpl) then) =
      __$$RouteStopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      int sequenceOrder,
      String? address,
      String? landmark,
      int? estimatedTimeFromPrevious,
      double? distanceFromPrevious});
}

/// @nodoc
class __$$RouteStopImplCopyWithImpl<$Res>
    extends _$RouteStopCopyWithImpl<$Res, _$RouteStopImpl>
    implements _$$RouteStopImplCopyWith<$Res> {
  __$$RouteStopImplCopyWithImpl(
      _$RouteStopImpl _value, $Res Function(_$RouteStopImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? sequenceOrder = null,
    Object? address = freezed,
    Object? landmark = freezed,
    Object? estimatedTimeFromPrevious = freezed,
    Object? distanceFromPrevious = freezed,
  }) {
    return _then(_$RouteStopImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      sequenceOrder: null == sequenceOrder
          ? _value.sequenceOrder
          : sequenceOrder // ignore: cast_nullable_to_non_nullable
              as int,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedTimeFromPrevious: freezed == estimatedTimeFromPrevious
          ? _value.estimatedTimeFromPrevious
          : estimatedTimeFromPrevious // ignore: cast_nullable_to_non_nullable
              as int?,
      distanceFromPrevious: freezed == distanceFromPrevious
          ? _value.distanceFromPrevious
          : distanceFromPrevious // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteStopImpl implements _RouteStop {
  const _$RouteStopImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.sequenceOrder,
      this.address,
      this.landmark,
      this.estimatedTimeFromPrevious,
      this.distanceFromPrevious});

  factory _$RouteStopImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteStopImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int sequenceOrder;
  @override
  final String? address;
  @override
  final String? landmark;
  @override
  final int? estimatedTimeFromPrevious;
  @override
  final double? distanceFromPrevious;

  @override
  String toString() {
    return 'RouteStop(id: $id, name: $name, latitude: $latitude, longitude: $longitude, sequenceOrder: $sequenceOrder, address: $address, landmark: $landmark, estimatedTimeFromPrevious: $estimatedTimeFromPrevious, distanceFromPrevious: $distanceFromPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteStopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.sequenceOrder, sequenceOrder) ||
                other.sequenceOrder == sequenceOrder) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.estimatedTimeFromPrevious,
                    estimatedTimeFromPrevious) ||
                other.estimatedTimeFromPrevious == estimatedTimeFromPrevious) &&
            (identical(other.distanceFromPrevious, distanceFromPrevious) ||
                other.distanceFromPrevious == distanceFromPrevious));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      latitude,
      longitude,
      sequenceOrder,
      address,
      landmark,
      estimatedTimeFromPrevious,
      distanceFromPrevious);

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteStopImplCopyWith<_$RouteStopImpl> get copyWith =>
      __$$RouteStopImplCopyWithImpl<_$RouteStopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteStopImplToJson(
      this,
    );
  }
}

abstract class _RouteStop implements RouteStop {
  const factory _RouteStop(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      required final int sequenceOrder,
      final String? address,
      final String? landmark,
      final int? estimatedTimeFromPrevious,
      final double? distanceFromPrevious}) = _$RouteStopImpl;

  factory _RouteStop.fromJson(Map<String, dynamic> json) =
      _$RouteStopImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int get sequenceOrder;
  @override
  String? get address;
  @override
  String? get landmark;
  @override
  int? get estimatedTimeFromPrevious;
  @override
  double? get distanceFromPrevious;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteStopImplCopyWith<_$RouteStopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Stop _$StopFromJson(Map<String, dynamic> json) {
  return _Stop.fromJson(json);
}

/// @nodoc
mixin _$Stop {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get landmark => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Stop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StopCopyWith<Stop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StopCopyWith<$Res> {
  factory $StopCopyWith(Stop value, $Res Function(Stop) then) =
      _$StopCopyWithImpl<$Res, Stop>;
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      String? address,
      String? landmark,
      String? companyId,
      DateTime? createdAt});
}

/// @nodoc
class _$StopCopyWithImpl<$Res, $Val extends Stop>
    implements $StopCopyWith<$Res> {
  _$StopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? landmark = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$StopImplCopyWith<$Res> implements $StopCopyWith<$Res> {
  factory _$$StopImplCopyWith(
          _$StopImpl value, $Res Function(_$StopImpl) then) =
      __$$StopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      String? address,
      String? landmark,
      String? companyId,
      DateTime? createdAt});
}

/// @nodoc
class __$$StopImplCopyWithImpl<$Res>
    extends _$StopCopyWithImpl<$Res, _$StopImpl>
    implements _$$StopImplCopyWith<$Res> {
  __$$StopImplCopyWithImpl(_$StopImpl _value, $Res Function(_$StopImpl) _then)
      : super(_value, _then);

  /// Create a copy of Stop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? landmark = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$StopImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$StopImpl implements _Stop {
  const _$StopImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.address,
      this.landmark,
      this.companyId,
      this.createdAt});

  factory _$StopImpl.fromJson(Map<String, dynamic> json) =>
      _$$StopImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  final String? landmark;
  @override
  final String? companyId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Stop(id: $id, name: $name, latitude: $latitude, longitude: $longitude, address: $address, landmark: $landmark, companyId: $companyId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, latitude, longitude,
      address, landmark, companyId, createdAt);

  /// Create a copy of Stop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StopImplCopyWith<_$StopImpl> get copyWith =>
      __$$StopImplCopyWithImpl<_$StopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StopImplToJson(
      this,
    );
  }
}

abstract class _Stop implements Stop {
  const factory _Stop(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      final String? address,
      final String? landmark,
      final String? companyId,
      final DateTime? createdAt}) = _$StopImpl;

  factory _Stop.fromJson(Map<String, dynamic> json) = _$StopImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  String? get landmark;
  @override
  String? get companyId;
  @override
  DateTime? get createdAt;

  /// Create a copy of Stop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StopImplCopyWith<_$StopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
