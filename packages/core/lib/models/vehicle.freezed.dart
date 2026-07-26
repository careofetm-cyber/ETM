// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return _Vehicle.fromJson(json);
}

/// @nodoc
mixin _$Vehicle {
  String get id => throw _privateConstructorUsedError;
  String get plateNumber => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int get seatingCapacity => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  VehicleStatus? get status => throw _privateConstructorUsedError;
  String? get driverId => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  double? get currentLatitude => throw _privateConstructorUsedError;
  double? get currentLongitude => throw _privateConstructorUsedError;
  DateTime? get lastLocationUpdate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleCopyWith<Vehicle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleCopyWith<$Res> {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) then) =
      _$VehicleCopyWithImpl<$Res, Vehicle>;
  @useResult
  $Res call(
      {String id,
      String plateNumber,
      String model,
      String brand,
      int year,
      int seatingCapacity,
      String? color,
      String? imageUrl,
      VehicleStatus? status,
      String? driverId,
      String? companyId,
      double? currentLatitude,
      double? currentLongitude,
      DateTime? lastLocationUpdate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$VehicleCopyWithImpl<$Res, $Val extends Vehicle>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plateNumber = null,
    Object? model = null,
    Object? brand = null,
    Object? year = null,
    Object? seatingCapacity = null,
    Object? color = freezed,
    Object? imageUrl = freezed,
    Object? status = freezed,
    Object? driverId = freezed,
    Object? companyId = freezed,
    Object? currentLatitude = freezed,
    Object? currentLongitude = freezed,
    Object? lastLocationUpdate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: null == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      seatingCapacity: null == seatingCapacity
          ? _value.seatingCapacity
          : seatingCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VehicleStatus?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentLatitude: freezed == currentLatitude
          ? _value.currentLatitude
          : currentLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      currentLongitude: freezed == currentLongitude
          ? _value.currentLongitude
          : currentLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lastLocationUpdate: freezed == lastLocationUpdate
          ? _value.lastLocationUpdate
          : lastLocationUpdate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VehicleImplCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$$VehicleImplCopyWith(
          _$VehicleImpl value, $Res Function(_$VehicleImpl) then) =
      __$$VehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String plateNumber,
      String model,
      String brand,
      int year,
      int seatingCapacity,
      String? color,
      String? imageUrl,
      VehicleStatus? status,
      String? driverId,
      String? companyId,
      double? currentLatitude,
      double? currentLongitude,
      DateTime? lastLocationUpdate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$VehicleImplCopyWithImpl<$Res>
    extends _$VehicleCopyWithImpl<$Res, _$VehicleImpl>
    implements _$$VehicleImplCopyWith<$Res> {
  __$$VehicleImplCopyWithImpl(
      _$VehicleImpl _value, $Res Function(_$VehicleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plateNumber = null,
    Object? model = null,
    Object? brand = null,
    Object? year = null,
    Object? seatingCapacity = null,
    Object? color = freezed,
    Object? imageUrl = freezed,
    Object? status = freezed,
    Object? driverId = freezed,
    Object? companyId = freezed,
    Object? currentLatitude = freezed,
    Object? currentLongitude = freezed,
    Object? lastLocationUpdate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VehicleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: null == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      seatingCapacity: null == seatingCapacity
          ? _value.seatingCapacity
          : seatingCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VehicleStatus?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentLatitude: freezed == currentLatitude
          ? _value.currentLatitude
          : currentLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      currentLongitude: freezed == currentLongitude
          ? _value.currentLongitude
          : currentLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lastLocationUpdate: freezed == lastLocationUpdate
          ? _value.lastLocationUpdate
          : lastLocationUpdate // ignore: cast_nullable_to_non_nullable
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
class _$VehicleImpl extends _Vehicle {
  const _$VehicleImpl(
      {required this.id,
      required this.plateNumber,
      required this.model,
      required this.brand,
      required this.year,
      required this.seatingCapacity,
      this.color,
      this.imageUrl,
      this.status,
      this.driverId,
      this.companyId,
      this.currentLatitude,
      this.currentLongitude,
      this.lastLocationUpdate,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$VehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleImplFromJson(json);

  @override
  final String id;
  @override
  final String plateNumber;
  @override
  final String model;
  @override
  final String brand;
  @override
  final int year;
  @override
  final int seatingCapacity;
  @override
  final String? color;
  @override
  final String? imageUrl;
  @override
  final VehicleStatus? status;
  @override
  final String? driverId;
  @override
  final String? companyId;
  @override
  final double? currentLatitude;
  @override
  final double? currentLongitude;
  @override
  final DateTime? lastLocationUpdate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Vehicle(id: $id, plateNumber: $plateNumber, model: $model, brand: $brand, year: $year, seatingCapacity: $seatingCapacity, color: $color, imageUrl: $imageUrl, status: $status, driverId: $driverId, companyId: $companyId, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, lastLocationUpdate: $lastLocationUpdate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.seatingCapacity, seatingCapacity) ||
                other.seatingCapacity == seatingCapacity) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.currentLatitude, currentLatitude) ||
                other.currentLatitude == currentLatitude) &&
            (identical(other.currentLongitude, currentLongitude) ||
                other.currentLongitude == currentLongitude) &&
            (identical(other.lastLocationUpdate, lastLocationUpdate) ||
                other.lastLocationUpdate == lastLocationUpdate) &&
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
      plateNumber,
      model,
      brand,
      year,
      seatingCapacity,
      color,
      imageUrl,
      status,
      driverId,
      companyId,
      currentLatitude,
      currentLongitude,
      lastLocationUpdate,
      createdAt,
      updatedAt);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      __$$VehicleImplCopyWithImpl<_$VehicleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleImplToJson(
      this,
    );
  }
}

abstract class _Vehicle extends Vehicle {
  const factory _Vehicle(
      {required final String id,
      required final String plateNumber,
      required final String model,
      required final String brand,
      required final int year,
      required final int seatingCapacity,
      final String? color,
      final String? imageUrl,
      final VehicleStatus? status,
      final String? driverId,
      final String? companyId,
      final double? currentLatitude,
      final double? currentLongitude,
      final DateTime? lastLocationUpdate,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$VehicleImpl;
  const _Vehicle._() : super._();

  factory _Vehicle.fromJson(Map<String, dynamic> json) = _$VehicleImpl.fromJson;

  @override
  String get id;
  @override
  String get plateNumber;
  @override
  String get model;
  @override
  String get brand;
  @override
  int get year;
  @override
  int get seatingCapacity;
  @override
  String? get color;
  @override
  String? get imageUrl;
  @override
  VehicleStatus? get status;
  @override
  String? get driverId;
  @override
  String? get companyId;
  @override
  double? get currentLatitude;
  @override
  double? get currentLongitude;
  @override
  DateTime? get lastLocationUpdate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VehicleInspection _$VehicleInspectionFromJson(Map<String, dynamic> json) {
  return _VehicleInspection.fromJson(json);
}

/// @nodoc
mixin _$VehicleInspection {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  DateTime get inspectionDate => throw _privateConstructorUsedError;
  bool get isPassed => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get issues => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VehicleInspection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleInspection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleInspectionCopyWith<VehicleInspection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleInspectionCopyWith<$Res> {
  factory $VehicleInspectionCopyWith(
          VehicleInspection value, $Res Function(VehicleInspection) then) =
      _$VehicleInspectionCopyWithImpl<$Res, VehicleInspection>;
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String driverId,
      DateTime inspectionDate,
      bool isPassed,
      String? notes,
      List<String>? issues,
      DateTime? createdAt});
}

/// @nodoc
class _$VehicleInspectionCopyWithImpl<$Res, $Val extends VehicleInspection>
    implements $VehicleInspectionCopyWith<$Res> {
  _$VehicleInspectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleInspection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? driverId = null,
    Object? inspectionDate = null,
    Object? isPassed = null,
    Object? notes = freezed,
    Object? issues = freezed,
    Object? createdAt = freezed,
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
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      inspectionDate: null == inspectionDate
          ? _value.inspectionDate
          : inspectionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPassed: null == isPassed
          ? _value.isPassed
          : isPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      issues: freezed == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleInspectionImplCopyWith<$Res>
    implements $VehicleInspectionCopyWith<$Res> {
  factory _$$VehicleInspectionImplCopyWith(_$VehicleInspectionImpl value,
          $Res Function(_$VehicleInspectionImpl) then) =
      __$$VehicleInspectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String driverId,
      DateTime inspectionDate,
      bool isPassed,
      String? notes,
      List<String>? issues,
      DateTime? createdAt});
}

/// @nodoc
class __$$VehicleInspectionImplCopyWithImpl<$Res>
    extends _$VehicleInspectionCopyWithImpl<$Res, _$VehicleInspectionImpl>
    implements _$$VehicleInspectionImplCopyWith<$Res> {
  __$$VehicleInspectionImplCopyWithImpl(_$VehicleInspectionImpl _value,
      $Res Function(_$VehicleInspectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of VehicleInspection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? driverId = null,
    Object? inspectionDate = null,
    Object? isPassed = null,
    Object? notes = freezed,
    Object? issues = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$VehicleInspectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      inspectionDate: null == inspectionDate
          ? _value.inspectionDate
          : inspectionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPassed: null == isPassed
          ? _value.isPassed
          : isPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      issues: freezed == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleInspectionImpl implements _VehicleInspection {
  const _$VehicleInspectionImpl(
      {required this.id,
      required this.vehicleId,
      required this.driverId,
      required this.inspectionDate,
      required this.isPassed,
      this.notes,
      final List<String>? issues,
      this.createdAt})
      : _issues = issues;

  factory _$VehicleInspectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleInspectionImplFromJson(json);

  @override
  final String id;
  @override
  final String vehicleId;
  @override
  final String driverId;
  @override
  final DateTime inspectionDate;
  @override
  final bool isPassed;
  @override
  final String? notes;
  final List<String>? _issues;
  @override
  List<String>? get issues {
    final value = _issues;
    if (value == null) return null;
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'VehicleInspection(id: $id, vehicleId: $vehicleId, driverId: $driverId, inspectionDate: $inspectionDate, isPassed: $isPassed, notes: $notes, issues: $issues, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleInspectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.inspectionDate, inspectionDate) ||
                other.inspectionDate == inspectionDate) &&
            (identical(other.isPassed, isPassed) ||
                other.isPassed == isPassed) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._issues, _issues) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vehicleId,
      driverId,
      inspectionDate,
      isPassed,
      notes,
      const DeepCollectionEquality().hash(_issues),
      createdAt);

  /// Create a copy of VehicleInspection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleInspectionImplCopyWith<_$VehicleInspectionImpl> get copyWith =>
      __$$VehicleInspectionImplCopyWithImpl<_$VehicleInspectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleInspectionImplToJson(
      this,
    );
  }
}

abstract class _VehicleInspection implements VehicleInspection {
  const factory _VehicleInspection(
      {required final String id,
      required final String vehicleId,
      required final String driverId,
      required final DateTime inspectionDate,
      required final bool isPassed,
      final String? notes,
      final List<String>? issues,
      final DateTime? createdAt}) = _$VehicleInspectionImpl;

  factory _VehicleInspection.fromJson(Map<String, dynamic> json) =
      _$VehicleInspectionImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  String get driverId;
  @override
  DateTime get inspectionDate;
  @override
  bool get isPassed;
  @override
  String? get notes;
  @override
  List<String>? get issues;
  @override
  DateTime? get createdAt;

  /// Create a copy of VehicleInspection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleInspectionImplCopyWith<_$VehicleInspectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
