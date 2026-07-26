// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VehicleDocument _$VehicleDocumentFromJson(Map<String, dynamic> json) {
  return _VehicleDocument.fromJson(json);
}

/// @nodoc
mixin _$VehicleDocument {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  String get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_type')
  String get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_number')
  String? get documentNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'issue_date')
  String? get issueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  String? get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_url')
  String get documentUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VehicleDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleDocumentCopyWith<VehicleDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleDocumentCopyWith<$Res> {
  factory $VehicleDocumentCopyWith(
          VehicleDocument value, $Res Function(VehicleDocument) then) =
      _$VehicleDocumentCopyWithImpl<$Res, VehicleDocument>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'document_type') String documentType,
      @JsonKey(name: 'document_number') String? documentNumber,
      @JsonKey(name: 'issue_date') String? issueDate,
      @JsonKey(name: 'expiry_date') String? expiryDate,
      @JsonKey(name: 'document_url') String documentUrl,
      String status,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$VehicleDocumentCopyWithImpl<$Res, $Val extends VehicleDocument>
    implements $VehicleDocumentCopyWith<$Res> {
  _$VehicleDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? companyId = null,
    Object? documentType = null,
    Object? documentNumber = freezed,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? documentUrl = null,
    Object? status = null,
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
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: freezed == documentNumber
          ? _value.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleDocumentImplCopyWith<$Res>
    implements $VehicleDocumentCopyWith<$Res> {
  factory _$$VehicleDocumentImplCopyWith(_$VehicleDocumentImpl value,
          $Res Function(_$VehicleDocumentImpl) then) =
      __$$VehicleDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vehicle_id') String vehicleId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'document_type') String documentType,
      @JsonKey(name: 'document_number') String? documentNumber,
      @JsonKey(name: 'issue_date') String? issueDate,
      @JsonKey(name: 'expiry_date') String? expiryDate,
      @JsonKey(name: 'document_url') String documentUrl,
      String status,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$VehicleDocumentImplCopyWithImpl<$Res>
    extends _$VehicleDocumentCopyWithImpl<$Res, _$VehicleDocumentImpl>
    implements _$$VehicleDocumentImplCopyWith<$Res> {
  __$$VehicleDocumentImplCopyWithImpl(
      _$VehicleDocumentImpl _value, $Res Function(_$VehicleDocumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of VehicleDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? companyId = null,
    Object? documentType = null,
    Object? documentNumber = freezed,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? documentUrl = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$VehicleDocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentNumber: freezed == documentNumber
          ? _value.documentNumber
          : documentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleDocumentImpl implements _VehicleDocument {
  const _$VehicleDocumentImpl(
      {required this.id,
      @JsonKey(name: 'vehicle_id') required this.vehicleId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'document_type') required this.documentType,
      @JsonKey(name: 'document_number') this.documentNumber,
      @JsonKey(name: 'issue_date') this.issueDate,
      @JsonKey(name: 'expiry_date') this.expiryDate,
      @JsonKey(name: 'document_url') this.documentUrl = '',
      this.status = 'valid',
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$VehicleDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleDocumentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'document_type')
  final String documentType;
  @override
  @JsonKey(name: 'document_number')
  final String? documentNumber;
  @override
  @JsonKey(name: 'issue_date')
  final String? issueDate;
  @override
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  @override
  @JsonKey(name: 'document_url')
  final String documentUrl;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'VehicleDocument(id: $id, vehicleId: $vehicleId, companyId: $companyId, documentType: $documentType, documentNumber: $documentNumber, issueDate: $issueDate, expiryDate: $expiryDate, documentUrl: $documentUrl, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentNumber, documentNumber) ||
                other.documentNumber == documentNumber) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vehicleId,
      companyId,
      documentType,
      documentNumber,
      issueDate,
      expiryDate,
      documentUrl,
      status,
      createdAt);

  /// Create a copy of VehicleDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleDocumentImplCopyWith<_$VehicleDocumentImpl> get copyWith =>
      __$$VehicleDocumentImplCopyWithImpl<_$VehicleDocumentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleDocumentImplToJson(
      this,
    );
  }
}

abstract class _VehicleDocument implements VehicleDocument {
  const factory _VehicleDocument(
          {required final String id,
          @JsonKey(name: 'vehicle_id') required final String vehicleId,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'document_type') required final String documentType,
          @JsonKey(name: 'document_number') final String? documentNumber,
          @JsonKey(name: 'issue_date') final String? issueDate,
          @JsonKey(name: 'expiry_date') final String? expiryDate,
          @JsonKey(name: 'document_url') final String documentUrl,
          final String status,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$VehicleDocumentImpl;

  factory _VehicleDocument.fromJson(Map<String, dynamic> json) =
      _$VehicleDocumentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vehicle_id')
  String get vehicleId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'document_type')
  String get documentType;
  @override
  @JsonKey(name: 'document_number')
  String? get documentNumber;
  @override
  @JsonKey(name: 'issue_date')
  String? get issueDate;
  @override
  @JsonKey(name: 'expiry_date')
  String? get expiryDate;
  @override
  @JsonKey(name: 'document_url')
  String get documentUrl;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of VehicleDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleDocumentImplCopyWith<_$VehicleDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
