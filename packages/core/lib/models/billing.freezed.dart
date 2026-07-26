// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BillingRecord _$BillingRecordFromJson(Map<String, dynamic> json) {
  return _BillingRecord.fromJson(json);
}

/// @nodoc
mixin _$BillingRecord {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  double get tripCost => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  double? get duration => throw _privateConstructorUsedError;
  int? get passengers => throw _privateConstructorUsedError;
  bool? get isBillable => throw _privateConstructorUsedError;
  String? get discardReason => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get month => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BillingRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingRecordCopyWith<BillingRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingRecordCopyWith<$Res> {
  factory $BillingRecordCopyWith(
          BillingRecord value, $Res Function(BillingRecord) then) =
      _$BillingRecordCopyWithImpl<$Res, BillingRecord>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String tripId,
      double tripCost,
      double distance,
      double? duration,
      int? passengers,
      bool? isBillable,
      String? discardReason,
      DateTime? completedAt,
      String? month,
      DateTime? createdAt});
}

/// @nodoc
class _$BillingRecordCopyWithImpl<$Res, $Val extends BillingRecord>
    implements $BillingRecordCopyWith<$Res> {
  _$BillingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? tripId = null,
    Object? tripCost = null,
    Object? distance = null,
    Object? duration = freezed,
    Object? passengers = freezed,
    Object? isBillable = freezed,
    Object? discardReason = freezed,
    Object? completedAt = freezed,
    Object? month = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      tripCost: null == tripCost
          ? _value.tripCost
          : tripCost // ignore: cast_nullable_to_non_nullable
              as double,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      passengers: freezed == passengers
          ? _value.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as int?,
      isBillable: freezed == isBillable
          ? _value.isBillable
          : isBillable // ignore: cast_nullable_to_non_nullable
              as bool?,
      discardReason: freezed == discardReason
          ? _value.discardReason
          : discardReason // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillingRecordImplCopyWith<$Res>
    implements $BillingRecordCopyWith<$Res> {
  factory _$$BillingRecordImplCopyWith(
          _$BillingRecordImpl value, $Res Function(_$BillingRecordImpl) then) =
      __$$BillingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String tripId,
      double tripCost,
      double distance,
      double? duration,
      int? passengers,
      bool? isBillable,
      String? discardReason,
      DateTime? completedAt,
      String? month,
      DateTime? createdAt});
}

/// @nodoc
class __$$BillingRecordImplCopyWithImpl<$Res>
    extends _$BillingRecordCopyWithImpl<$Res, _$BillingRecordImpl>
    implements _$$BillingRecordImplCopyWith<$Res> {
  __$$BillingRecordImplCopyWithImpl(
      _$BillingRecordImpl _value, $Res Function(_$BillingRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? tripId = null,
    Object? tripCost = null,
    Object? distance = null,
    Object? duration = freezed,
    Object? passengers = freezed,
    Object? isBillable = freezed,
    Object? discardReason = freezed,
    Object? completedAt = freezed,
    Object? month = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$BillingRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      tripCost: null == tripCost
          ? _value.tripCost
          : tripCost // ignore: cast_nullable_to_non_nullable
              as double,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      passengers: freezed == passengers
          ? _value.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as int?,
      isBillable: freezed == isBillable
          ? _value.isBillable
          : isBillable // ignore: cast_nullable_to_non_nullable
              as bool?,
      discardReason: freezed == discardReason
          ? _value.discardReason
          : discardReason // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
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
class _$BillingRecordImpl implements _BillingRecord {
  const _$BillingRecordImpl(
      {required this.id,
      required this.companyId,
      required this.tripId,
      required this.tripCost,
      required this.distance,
      this.duration,
      this.passengers,
      this.isBillable,
      this.discardReason,
      this.completedAt,
      this.month,
      this.createdAt});

  factory _$BillingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String tripId;
  @override
  final double tripCost;
  @override
  final double distance;
  @override
  final double? duration;
  @override
  final int? passengers;
  @override
  final bool? isBillable;
  @override
  final String? discardReason;
  @override
  final DateTime? completedAt;
  @override
  final String? month;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BillingRecord(id: $id, companyId: $companyId, tripId: $tripId, tripCost: $tripCost, distance: $distance, duration: $duration, passengers: $passengers, isBillable: $isBillable, discardReason: $discardReason, completedAt: $completedAt, month: $month, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.tripCost, tripCost) ||
                other.tripCost == tripCost) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.passengers, passengers) ||
                other.passengers == passengers) &&
            (identical(other.isBillable, isBillable) ||
                other.isBillable == isBillable) &&
            (identical(other.discardReason, discardReason) ||
                other.discardReason == discardReason) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      tripId,
      tripCost,
      distance,
      duration,
      passengers,
      isBillable,
      discardReason,
      completedAt,
      month,
      createdAt);

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingRecordImplCopyWith<_$BillingRecordImpl> get copyWith =>
      __$$BillingRecordImplCopyWithImpl<_$BillingRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingRecordImplToJson(
      this,
    );
  }
}

abstract class _BillingRecord implements BillingRecord {
  const factory _BillingRecord(
      {required final String id,
      required final String companyId,
      required final String tripId,
      required final double tripCost,
      required final double distance,
      final double? duration,
      final int? passengers,
      final bool? isBillable,
      final String? discardReason,
      final DateTime? completedAt,
      final String? month,
      final DateTime? createdAt}) = _$BillingRecordImpl;

  factory _BillingRecord.fromJson(Map<String, dynamic> json) =
      _$BillingRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get tripId;
  @override
  double get tripCost;
  @override
  double get distance;
  @override
  double? get duration;
  @override
  int? get passengers;
  @override
  bool? get isBillable;
  @override
  String? get discardReason;
  @override
  DateTime? get completedAt;
  @override
  String? get month;
  @override
  DateTime? get createdAt;

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingRecordImplCopyWith<_$BillingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get month => throw _privateConstructorUsedError;
  int get totalTrips => throw _privateConstructorUsedError;
  int get billableTrips => throw _privateConstructorUsedError;
  int get discardedTrips => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String month,
      int totalTrips,
      int billableTrips,
      int discardedTrips,
      double totalAmount,
      String status,
      DateTime? dueDate,
      DateTime? paidAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? month = null,
    Object? totalTrips = null,
    Object? billableTrips = null,
    Object? discardedTrips = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? dueDate = freezed,
    Object? paidAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalTrips: null == totalTrips
          ? _value.totalTrips
          : totalTrips // ignore: cast_nullable_to_non_nullable
              as int,
      billableTrips: null == billableTrips
          ? _value.billableTrips
          : billableTrips // ignore: cast_nullable_to_non_nullable
              as int,
      discardedTrips: null == discardedTrips
          ? _value.discardedTrips
          : discardedTrips // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String month,
      int totalTrips,
      int billableTrips,
      int discardedTrips,
      double totalAmount,
      String status,
      DateTime? dueDate,
      DateTime? paidAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? month = null,
    Object? totalTrips = null,
    Object? billableTrips = null,
    Object? discardedTrips = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? dueDate = freezed,
    Object? paidAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalTrips: null == totalTrips
          ? _value.totalTrips
          : totalTrips // ignore: cast_nullable_to_non_nullable
              as int,
      billableTrips: null == billableTrips
          ? _value.billableTrips
          : billableTrips // ignore: cast_nullable_to_non_nullable
              as int,
      discardedTrips: null == discardedTrips
          ? _value.discardedTrips
          : discardedTrips // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
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
class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl(
      {required this.id,
      required this.companyId,
      required this.month,
      required this.totalTrips,
      required this.billableTrips,
      required this.discardedTrips,
      required this.totalAmount,
      required this.status,
      this.dueDate,
      this.paidAt,
      this.createdAt,
      this.updatedAt});

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String month;
  @override
  final int totalTrips;
  @override
  final int billableTrips;
  @override
  final int discardedTrips;
  @override
  final double totalAmount;
  @override
  final String status;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? paidAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Invoice(id: $id, companyId: $companyId, month: $month, totalTrips: $totalTrips, billableTrips: $billableTrips, discardedTrips: $discardedTrips, totalAmount: $totalAmount, status: $status, dueDate: $dueDate, paidAt: $paidAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalTrips, totalTrips) ||
                other.totalTrips == totalTrips) &&
            (identical(other.billableTrips, billableTrips) ||
                other.billableTrips == billableTrips) &&
            (identical(other.discardedTrips, discardedTrips) ||
                other.discardedTrips == discardedTrips) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
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
      companyId,
      month,
      totalTrips,
      billableTrips,
      discardedTrips,
      totalAmount,
      status,
      dueDate,
      paidAt,
      createdAt,
      updatedAt);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(
      this,
    );
  }
}

abstract class _Invoice implements Invoice {
  const factory _Invoice(
      {required final String id,
      required final String companyId,
      required final String month,
      required final int totalTrips,
      required final int billableTrips,
      required final int discardedTrips,
      required final double totalAmount,
      required final String status,
      final DateTime? dueDate,
      final DateTime? paidAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$InvoiceImpl;

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get month;
  @override
  int get totalTrips;
  @override
  int get billableTrips;
  @override
  int get discardedTrips;
  @override
  double get totalAmount;
  @override
  String get status;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get paidAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyBillingSummary _$CompanyBillingSummaryFromJson(
    Map<String, dynamic> json) {
  return _CompanyBillingSummary.fromJson(json);
}

/// @nodoc
mixin _$CompanyBillingSummary {
  String get companyId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  int get totalTripsThisMonth => throw _privateConstructorUsedError;
  int get billableTripsThisMonth => throw _privateConstructorUsedError;
  int get discardedTripsThisMonth => throw _privateConstructorUsedError;
  double get totalAmountThisMonth => throw _privateConstructorUsedError;
  int get monthlyTripLimit => throw _privateConstructorUsedError;
  double get tripCostPerTrip => throw _privateConstructorUsedError;
  double get minimumKmForBilling => throw _privateConstructorUsedError;
  String get plan => throw _privateConstructorUsedError;
  String get subscriptionStatus => throw _privateConstructorUsedError;

  /// Serializes this CompanyBillingSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyBillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyBillingSummaryCopyWith<CompanyBillingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyBillingSummaryCopyWith<$Res> {
  factory $CompanyBillingSummaryCopyWith(CompanyBillingSummary value,
          $Res Function(CompanyBillingSummary) then) =
      _$CompanyBillingSummaryCopyWithImpl<$Res, CompanyBillingSummary>;
  @useResult
  $Res call(
      {String companyId,
      String companyName,
      int totalTripsThisMonth,
      int billableTripsThisMonth,
      int discardedTripsThisMonth,
      double totalAmountThisMonth,
      int monthlyTripLimit,
      double tripCostPerTrip,
      double minimumKmForBilling,
      String plan,
      String subscriptionStatus});
}

/// @nodoc
class _$CompanyBillingSummaryCopyWithImpl<$Res,
        $Val extends CompanyBillingSummary>
    implements $CompanyBillingSummaryCopyWith<$Res> {
  _$CompanyBillingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyBillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? totalTripsThisMonth = null,
    Object? billableTripsThisMonth = null,
    Object? discardedTripsThisMonth = null,
    Object? totalAmountThisMonth = null,
    Object? monthlyTripLimit = null,
    Object? tripCostPerTrip = null,
    Object? minimumKmForBilling = null,
    Object? plan = null,
    Object? subscriptionStatus = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      totalTripsThisMonth: null == totalTripsThisMonth
          ? _value.totalTripsThisMonth
          : totalTripsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      billableTripsThisMonth: null == billableTripsThisMonth
          ? _value.billableTripsThisMonth
          : billableTripsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      discardedTripsThisMonth: null == discardedTripsThisMonth
          ? _value.discardedTripsThisMonth
          : discardedTripsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmountThisMonth: null == totalAmountThisMonth
          ? _value.totalAmountThisMonth
          : totalAmountThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyTripLimit: null == monthlyTripLimit
          ? _value.monthlyTripLimit
          : monthlyTripLimit // ignore: cast_nullable_to_non_nullable
              as int,
      tripCostPerTrip: null == tripCostPerTrip
          ? _value.tripCostPerTrip
          : tripCostPerTrip // ignore: cast_nullable_to_non_nullable
              as double,
      minimumKmForBilling: null == minimumKmForBilling
          ? _value.minimumKmForBilling
          : minimumKmForBilling // ignore: cast_nullable_to_non_nullable
              as double,
      plan: null == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyBillingSummaryImplCopyWith<$Res>
    implements $CompanyBillingSummaryCopyWith<$Res> {
  factory _$$CompanyBillingSummaryImplCopyWith(
          _$CompanyBillingSummaryImpl value,
          $Res Function(_$CompanyBillingSummaryImpl) then) =
      __$$CompanyBillingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyId,
      String companyName,
      int totalTripsThisMonth,
      int billableTripsThisMonth,
      int discardedTripsThisMonth,
      double totalAmountThisMonth,
      int monthlyTripLimit,
      double tripCostPerTrip,
      double minimumKmForBilling,
      String plan,
      String subscriptionStatus});
}

/// @nodoc
class __$$CompanyBillingSummaryImplCopyWithImpl<$Res>
    extends _$CompanyBillingSummaryCopyWithImpl<$Res,
        _$CompanyBillingSummaryImpl>
    implements _$$CompanyBillingSummaryImplCopyWith<$Res> {
  __$$CompanyBillingSummaryImplCopyWithImpl(_$CompanyBillingSummaryImpl _value,
      $Res Function(_$CompanyBillingSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyBillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? totalTripsThisMonth = null,
    Object? billableTripsThisMonth = null,
    Object? discardedTripsThisMonth = null,
    Object? totalAmountThisMonth = null,
    Object? monthlyTripLimit = null,
    Object? tripCostPerTrip = null,
    Object? minimumKmForBilling = null,
    Object? plan = null,
    Object? subscriptionStatus = null,
  }) {
    return _then(_$CompanyBillingSummaryImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      totalTripsThisMonth: null == totalTripsThisMonth
          ? _value.totalTripsThisMonth
          : totalTripsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      billableTripsThisMonth: null == billableTripsThisMonth
          ? _value.billableTripsThisMonth
          : billableTripsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      discardedTripsThisMonth: null == discardedTripsThisMonth
          ? _value.discardedTripsThisMonth
          : discardedTripsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmountThisMonth: null == totalAmountThisMonth
          ? _value.totalAmountThisMonth
          : totalAmountThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyTripLimit: null == monthlyTripLimit
          ? _value.monthlyTripLimit
          : monthlyTripLimit // ignore: cast_nullable_to_non_nullable
              as int,
      tripCostPerTrip: null == tripCostPerTrip
          ? _value.tripCostPerTrip
          : tripCostPerTrip // ignore: cast_nullable_to_non_nullable
              as double,
      minimumKmForBilling: null == minimumKmForBilling
          ? _value.minimumKmForBilling
          : minimumKmForBilling // ignore: cast_nullable_to_non_nullable
              as double,
      plan: null == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyBillingSummaryImpl implements _CompanyBillingSummary {
  const _$CompanyBillingSummaryImpl(
      {required this.companyId,
      required this.companyName,
      required this.totalTripsThisMonth,
      required this.billableTripsThisMonth,
      required this.discardedTripsThisMonth,
      required this.totalAmountThisMonth,
      required this.monthlyTripLimit,
      required this.tripCostPerTrip,
      required this.minimumKmForBilling,
      required this.plan,
      required this.subscriptionStatus});

  factory _$CompanyBillingSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyBillingSummaryImplFromJson(json);

  @override
  final String companyId;
  @override
  final String companyName;
  @override
  final int totalTripsThisMonth;
  @override
  final int billableTripsThisMonth;
  @override
  final int discardedTripsThisMonth;
  @override
  final double totalAmountThisMonth;
  @override
  final int monthlyTripLimit;
  @override
  final double tripCostPerTrip;
  @override
  final double minimumKmForBilling;
  @override
  final String plan;
  @override
  final String subscriptionStatus;

  @override
  String toString() {
    return 'CompanyBillingSummary(companyId: $companyId, companyName: $companyName, totalTripsThisMonth: $totalTripsThisMonth, billableTripsThisMonth: $billableTripsThisMonth, discardedTripsThisMonth: $discardedTripsThisMonth, totalAmountThisMonth: $totalAmountThisMonth, monthlyTripLimit: $monthlyTripLimit, tripCostPerTrip: $tripCostPerTrip, minimumKmForBilling: $minimumKmForBilling, plan: $plan, subscriptionStatus: $subscriptionStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyBillingSummaryImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.totalTripsThisMonth, totalTripsThisMonth) ||
                other.totalTripsThisMonth == totalTripsThisMonth) &&
            (identical(other.billableTripsThisMonth, billableTripsThisMonth) ||
                other.billableTripsThisMonth == billableTripsThisMonth) &&
            (identical(
                    other.discardedTripsThisMonth, discardedTripsThisMonth) ||
                other.discardedTripsThisMonth == discardedTripsThisMonth) &&
            (identical(other.totalAmountThisMonth, totalAmountThisMonth) ||
                other.totalAmountThisMonth == totalAmountThisMonth) &&
            (identical(other.monthlyTripLimit, monthlyTripLimit) ||
                other.monthlyTripLimit == monthlyTripLimit) &&
            (identical(other.tripCostPerTrip, tripCostPerTrip) ||
                other.tripCostPerTrip == tripCostPerTrip) &&
            (identical(other.minimumKmForBilling, minimumKmForBilling) ||
                other.minimumKmForBilling == minimumKmForBilling) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyId,
      companyName,
      totalTripsThisMonth,
      billableTripsThisMonth,
      discardedTripsThisMonth,
      totalAmountThisMonth,
      monthlyTripLimit,
      tripCostPerTrip,
      minimumKmForBilling,
      plan,
      subscriptionStatus);

  /// Create a copy of CompanyBillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyBillingSummaryImplCopyWith<_$CompanyBillingSummaryImpl>
      get copyWith => __$$CompanyBillingSummaryImplCopyWithImpl<
          _$CompanyBillingSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyBillingSummaryImplToJson(
      this,
    );
  }
}

abstract class _CompanyBillingSummary implements CompanyBillingSummary {
  const factory _CompanyBillingSummary(
      {required final String companyId,
      required final String companyName,
      required final int totalTripsThisMonth,
      required final int billableTripsThisMonth,
      required final int discardedTripsThisMonth,
      required final double totalAmountThisMonth,
      required final int monthlyTripLimit,
      required final double tripCostPerTrip,
      required final double minimumKmForBilling,
      required final String plan,
      required final String subscriptionStatus}) = _$CompanyBillingSummaryImpl;

  factory _CompanyBillingSummary.fromJson(Map<String, dynamic> json) =
      _$CompanyBillingSummaryImpl.fromJson;

  @override
  String get companyId;
  @override
  String get companyName;
  @override
  int get totalTripsThisMonth;
  @override
  int get billableTripsThisMonth;
  @override
  int get discardedTripsThisMonth;
  @override
  double get totalAmountThisMonth;
  @override
  int get monthlyTripLimit;
  @override
  double get tripCostPerTrip;
  @override
  double get minimumKmForBilling;
  @override
  String get plan;
  @override
  String get subscriptionStatus;

  /// Create a copy of CompanyBillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyBillingSummaryImplCopyWith<_$CompanyBillingSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
