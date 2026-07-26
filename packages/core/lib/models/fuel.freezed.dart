// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fuel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FuelLog _$FuelLogFromJson(Map<String, dynamic> json) {
  return _FuelLog.fromJson(json);
}

/// @nodoc
mixin _$FuelLog {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get pricePerUnit => throw _privateConstructorUsedError;
  double get totalCost => throw _privateConstructorUsedError;
  double get odometerReading => throw _privateConstructorUsedError;
  String? get fuelType => throw _privateConstructorUsedError;
  String? get gasStation => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FuelLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FuelLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FuelLogCopyWith<FuelLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelLogCopyWith<$Res> {
  factory $FuelLogCopyWith(FuelLog value, $Res Function(FuelLog) then) =
      _$FuelLogCopyWithImpl<$Res, FuelLog>;
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String driverId,
      DateTime date,
      double amount,
      double pricePerUnit,
      double totalCost,
      double odometerReading,
      String? fuelType,
      String? gasStation,
      String? notes,
      DateTime? createdAt});
}

/// @nodoc
class _$FuelLogCopyWithImpl<$Res, $Val extends FuelLog>
    implements $FuelLogCopyWith<$Res> {
  _$FuelLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FuelLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? driverId = null,
    Object? date = null,
    Object? amount = null,
    Object? pricePerUnit = null,
    Object? totalCost = null,
    Object? odometerReading = null,
    Object? fuelType = freezed,
    Object? gasStation = freezed,
    Object? notes = freezed,
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerUnit: null == pricePerUnit
          ? _value.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      odometerReading: null == odometerReading
          ? _value.odometerReading
          : odometerReading // ignore: cast_nullable_to_non_nullable
              as double,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      gasStation: freezed == gasStation
          ? _value.gasStation
          : gasStation // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelLogImplCopyWith<$Res> implements $FuelLogCopyWith<$Res> {
  factory _$$FuelLogImplCopyWith(
          _$FuelLogImpl value, $Res Function(_$FuelLogImpl) then) =
      __$$FuelLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String driverId,
      DateTime date,
      double amount,
      double pricePerUnit,
      double totalCost,
      double odometerReading,
      String? fuelType,
      String? gasStation,
      String? notes,
      DateTime? createdAt});
}

/// @nodoc
class __$$FuelLogImplCopyWithImpl<$Res>
    extends _$FuelLogCopyWithImpl<$Res, _$FuelLogImpl>
    implements _$$FuelLogImplCopyWith<$Res> {
  __$$FuelLogImplCopyWithImpl(
      _$FuelLogImpl _value, $Res Function(_$FuelLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of FuelLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? driverId = null,
    Object? date = null,
    Object? amount = null,
    Object? pricePerUnit = null,
    Object? totalCost = null,
    Object? odometerReading = null,
    Object? fuelType = freezed,
    Object? gasStation = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$FuelLogImpl(
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerUnit: null == pricePerUnit
          ? _value.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      odometerReading: null == odometerReading
          ? _value.odometerReading
          : odometerReading // ignore: cast_nullable_to_non_nullable
              as double,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      gasStation: freezed == gasStation
          ? _value.gasStation
          : gasStation // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
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
class _$FuelLogImpl implements _FuelLog {
  const _$FuelLogImpl(
      {required this.id,
      required this.vehicleId,
      required this.driverId,
      required this.date,
      required this.amount,
      required this.pricePerUnit,
      required this.totalCost,
      required this.odometerReading,
      this.fuelType,
      this.gasStation,
      this.notes,
      this.createdAt});

  factory _$FuelLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelLogImplFromJson(json);

  @override
  final String id;
  @override
  final String vehicleId;
  @override
  final String driverId;
  @override
  final DateTime date;
  @override
  final double amount;
  @override
  final double pricePerUnit;
  @override
  final double totalCost;
  @override
  final double odometerReading;
  @override
  final String? fuelType;
  @override
  final String? gasStation;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FuelLog(id: $id, vehicleId: $vehicleId, driverId: $driverId, date: $date, amount: $amount, pricePerUnit: $pricePerUnit, totalCost: $totalCost, odometerReading: $odometerReading, fuelType: $fuelType, gasStation: $gasStation, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.pricePerUnit, pricePerUnit) ||
                other.pricePerUnit == pricePerUnit) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.odometerReading, odometerReading) ||
                other.odometerReading == odometerReading) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.gasStation, gasStation) ||
                other.gasStation == gasStation) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
      date,
      amount,
      pricePerUnit,
      totalCost,
      odometerReading,
      fuelType,
      gasStation,
      notes,
      createdAt);

  /// Create a copy of FuelLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelLogImplCopyWith<_$FuelLogImpl> get copyWith =>
      __$$FuelLogImplCopyWithImpl<_$FuelLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelLogImplToJson(
      this,
    );
  }
}

abstract class _FuelLog implements FuelLog {
  const factory _FuelLog(
      {required final String id,
      required final String vehicleId,
      required final String driverId,
      required final DateTime date,
      required final double amount,
      required final double pricePerUnit,
      required final double totalCost,
      required final double odometerReading,
      final String? fuelType,
      final String? gasStation,
      final String? notes,
      final DateTime? createdAt}) = _$FuelLogImpl;

  factory _FuelLog.fromJson(Map<String, dynamic> json) = _$FuelLogImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  String get driverId;
  @override
  DateTime get date;
  @override
  double get amount;
  @override
  double get pricePerUnit;
  @override
  double get totalCost;
  @override
  double get odometerReading;
  @override
  String? get fuelType;
  @override
  String? get gasStation;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;

  /// Create a copy of FuelLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FuelLogImplCopyWith<_$FuelLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Maintenance _$MaintenanceFromJson(Map<String, dynamic> json) {
  return _Maintenance.fromJson(json);
}

/// @nodoc
mixin _$Maintenance {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  MaintenanceType get type => throw _privateConstructorUsedError;
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  DateTime? get completedDate => throw _privateConstructorUsedError;
  MaintenanceStatus get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get cost => throw _privateConstructorUsedError;
  String? get serviceProvider => throw _privateConstructorUsedError;
  int? get odometerAtService => throw _privateConstructorUsedError;
  int? get nextServiceOdometer => throw _privateConstructorUsedError;
  DateTime? get nextServiceDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get documents => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Maintenance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Maintenance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceCopyWith<Maintenance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceCopyWith<$Res> {
  factory $MaintenanceCopyWith(
          Maintenance value, $Res Function(Maintenance) then) =
      _$MaintenanceCopyWithImpl<$Res, Maintenance>;
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      MaintenanceType type,
      DateTime scheduledDate,
      DateTime? completedDate,
      MaintenanceStatus status,
      String? description,
      double? cost,
      String? serviceProvider,
      int? odometerAtService,
      int? nextServiceOdometer,
      DateTime? nextServiceDate,
      String? notes,
      List<String>? documents,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MaintenanceCopyWithImpl<$Res, $Val extends Maintenance>
    implements $MaintenanceCopyWith<$Res> {
  _$MaintenanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Maintenance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? type = null,
    Object? scheduledDate = null,
    Object? completedDate = freezed,
    Object? status = null,
    Object? description = freezed,
    Object? cost = freezed,
    Object? serviceProvider = freezed,
    Object? odometerAtService = freezed,
    Object? nextServiceOdometer = freezed,
    Object? nextServiceDate = freezed,
    Object? notes = freezed,
    Object? documents = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MaintenanceType,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedDate: freezed == completedDate
          ? _value.completedDate
          : completedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MaintenanceStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceProvider: freezed == serviceProvider
          ? _value.serviceProvider
          : serviceProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      odometerAtService: freezed == odometerAtService
          ? _value.odometerAtService
          : odometerAtService // ignore: cast_nullable_to_non_nullable
              as int?,
      nextServiceOdometer: freezed == nextServiceOdometer
          ? _value.nextServiceOdometer
          : nextServiceOdometer // ignore: cast_nullable_to_non_nullable
              as int?,
      nextServiceDate: freezed == nextServiceDate
          ? _value.nextServiceDate
          : nextServiceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      documents: freezed == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
abstract class _$$MaintenanceImplCopyWith<$Res>
    implements $MaintenanceCopyWith<$Res> {
  factory _$$MaintenanceImplCopyWith(
          _$MaintenanceImpl value, $Res Function(_$MaintenanceImpl) then) =
      __$$MaintenanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      MaintenanceType type,
      DateTime scheduledDate,
      DateTime? completedDate,
      MaintenanceStatus status,
      String? description,
      double? cost,
      String? serviceProvider,
      int? odometerAtService,
      int? nextServiceOdometer,
      DateTime? nextServiceDate,
      String? notes,
      List<String>? documents,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$MaintenanceImplCopyWithImpl<$Res>
    extends _$MaintenanceCopyWithImpl<$Res, _$MaintenanceImpl>
    implements _$$MaintenanceImplCopyWith<$Res> {
  __$$MaintenanceImplCopyWithImpl(
      _$MaintenanceImpl _value, $Res Function(_$MaintenanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Maintenance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? type = null,
    Object? scheduledDate = null,
    Object? completedDate = freezed,
    Object? status = null,
    Object? description = freezed,
    Object? cost = freezed,
    Object? serviceProvider = freezed,
    Object? odometerAtService = freezed,
    Object? nextServiceOdometer = freezed,
    Object? nextServiceDate = freezed,
    Object? notes = freezed,
    Object? documents = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MaintenanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MaintenanceType,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedDate: freezed == completedDate
          ? _value.completedDate
          : completedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MaintenanceStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceProvider: freezed == serviceProvider
          ? _value.serviceProvider
          : serviceProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      odometerAtService: freezed == odometerAtService
          ? _value.odometerAtService
          : odometerAtService // ignore: cast_nullable_to_non_nullable
              as int?,
      nextServiceOdometer: freezed == nextServiceOdometer
          ? _value.nextServiceOdometer
          : nextServiceOdometer // ignore: cast_nullable_to_non_nullable
              as int?,
      nextServiceDate: freezed == nextServiceDate
          ? _value.nextServiceDate
          : nextServiceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      documents: freezed == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
class _$MaintenanceImpl implements _Maintenance {
  const _$MaintenanceImpl(
      {required this.id,
      required this.vehicleId,
      required this.type,
      required this.scheduledDate,
      this.completedDate,
      required this.status,
      this.description,
      this.cost,
      this.serviceProvider,
      this.odometerAtService,
      this.nextServiceOdometer,
      this.nextServiceDate,
      this.notes,
      final List<String>? documents,
      this.createdAt,
      this.updatedAt})
      : _documents = documents;

  factory _$MaintenanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaintenanceImplFromJson(json);

  @override
  final String id;
  @override
  final String vehicleId;
  @override
  final MaintenanceType type;
  @override
  final DateTime scheduledDate;
  @override
  final DateTime? completedDate;
  @override
  final MaintenanceStatus status;
  @override
  final String? description;
  @override
  final double? cost;
  @override
  final String? serviceProvider;
  @override
  final int? odometerAtService;
  @override
  final int? nextServiceOdometer;
  @override
  final DateTime? nextServiceDate;
  @override
  final String? notes;
  final List<String>? _documents;
  @override
  List<String>? get documents {
    final value = _documents;
    if (value == null) return null;
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Maintenance(id: $id, vehicleId: $vehicleId, type: $type, scheduledDate: $scheduledDate, completedDate: $completedDate, status: $status, description: $description, cost: $cost, serviceProvider: $serviceProvider, odometerAtService: $odometerAtService, nextServiceOdometer: $nextServiceOdometer, nextServiceDate: $nextServiceDate, notes: $notes, documents: $documents, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.completedDate, completedDate) ||
                other.completedDate == completedDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.serviceProvider, serviceProvider) ||
                other.serviceProvider == serviceProvider) &&
            (identical(other.odometerAtService, odometerAtService) ||
                other.odometerAtService == odometerAtService) &&
            (identical(other.nextServiceOdometer, nextServiceOdometer) ||
                other.nextServiceOdometer == nextServiceOdometer) &&
            (identical(other.nextServiceDate, nextServiceDate) ||
                other.nextServiceDate == nextServiceDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
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
      vehicleId,
      type,
      scheduledDate,
      completedDate,
      status,
      description,
      cost,
      serviceProvider,
      odometerAtService,
      nextServiceOdometer,
      nextServiceDate,
      notes,
      const DeepCollectionEquality().hash(_documents),
      createdAt,
      updatedAt);

  /// Create a copy of Maintenance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceImplCopyWith<_$MaintenanceImpl> get copyWith =>
      __$$MaintenanceImplCopyWithImpl<_$MaintenanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceImplToJson(
      this,
    );
  }
}

abstract class _Maintenance implements Maintenance {
  const factory _Maintenance(
      {required final String id,
      required final String vehicleId,
      required final MaintenanceType type,
      required final DateTime scheduledDate,
      final DateTime? completedDate,
      required final MaintenanceStatus status,
      final String? description,
      final double? cost,
      final String? serviceProvider,
      final int? odometerAtService,
      final int? nextServiceOdometer,
      final DateTime? nextServiceDate,
      final String? notes,
      final List<String>? documents,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$MaintenanceImpl;

  factory _Maintenance.fromJson(Map<String, dynamic> json) =
      _$MaintenanceImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  MaintenanceType get type;
  @override
  DateTime get scheduledDate;
  @override
  DateTime? get completedDate;
  @override
  MaintenanceStatus get status;
  @override
  String? get description;
  @override
  double? get cost;
  @override
  String? get serviceProvider;
  @override
  int? get odometerAtService;
  @override
  int? get nextServiceOdometer;
  @override
  DateTime? get nextServiceDate;
  @override
  String? get notes;
  @override
  List<String>? get documents;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Maintenance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceImplCopyWith<_$MaintenanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
