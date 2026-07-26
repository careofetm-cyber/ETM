// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hcm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HcmConfig _$HcmConfigFromJson(Map<String, dynamic> json) {
  return _HcmConfig.fromJson(json);
}

/// @nodoc
mixin _$HcmConfig {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_endpoint')
  String? get apiEndpoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'api_key')
  String? get apiKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_employees')
  bool get syncEmployees => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_attendance')
  bool get syncAttendance => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_interval_hours')
  int get syncIntervalHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_sync_at')
  String? get lastSyncAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HcmConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HcmConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HcmConfigCopyWith<HcmConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HcmConfigCopyWith<$Res> {
  factory $HcmConfigCopyWith(HcmConfig value, $Res Function(HcmConfig) then) =
      _$HcmConfigCopyWithImpl<$Res, HcmConfig>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'company_id') String companyId,
      String provider,
      @JsonKey(name: 'api_endpoint') String? apiEndpoint,
      @JsonKey(name: 'api_key') String? apiKey,
      @JsonKey(name: 'sync_employees') bool syncEmployees,
      @JsonKey(name: 'sync_attendance') bool syncAttendance,
      @JsonKey(name: 'sync_interval_hours') int syncIntervalHours,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_sync_at') String? lastSyncAt,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$HcmConfigCopyWithImpl<$Res, $Val extends HcmConfig>
    implements $HcmConfigCopyWith<$Res> {
  _$HcmConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HcmConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? provider = null,
    Object? apiEndpoint = freezed,
    Object? apiKey = freezed,
    Object? syncEmployees = null,
    Object? syncAttendance = null,
    Object? syncIntervalHours = null,
    Object? isActive = null,
    Object? lastSyncAt = freezed,
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
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      apiEndpoint: freezed == apiEndpoint
          ? _value.apiEndpoint
          : apiEndpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      syncEmployees: null == syncEmployees
          ? _value.syncEmployees
          : syncEmployees // ignore: cast_nullable_to_non_nullable
              as bool,
      syncAttendance: null == syncAttendance
          ? _value.syncAttendance
          : syncAttendance // ignore: cast_nullable_to_non_nullable
              as bool,
      syncIntervalHours: null == syncIntervalHours
          ? _value.syncIntervalHours
          : syncIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncAt: freezed == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HcmConfigImplCopyWith<$Res>
    implements $HcmConfigCopyWith<$Res> {
  factory _$$HcmConfigImplCopyWith(
          _$HcmConfigImpl value, $Res Function(_$HcmConfigImpl) then) =
      __$$HcmConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'company_id') String companyId,
      String provider,
      @JsonKey(name: 'api_endpoint') String? apiEndpoint,
      @JsonKey(name: 'api_key') String? apiKey,
      @JsonKey(name: 'sync_employees') bool syncEmployees,
      @JsonKey(name: 'sync_attendance') bool syncAttendance,
      @JsonKey(name: 'sync_interval_hours') int syncIntervalHours,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_sync_at') String? lastSyncAt,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$HcmConfigImplCopyWithImpl<$Res>
    extends _$HcmConfigCopyWithImpl<$Res, _$HcmConfigImpl>
    implements _$$HcmConfigImplCopyWith<$Res> {
  __$$HcmConfigImplCopyWithImpl(
      _$HcmConfigImpl _value, $Res Function(_$HcmConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of HcmConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? provider = null,
    Object? apiEndpoint = freezed,
    Object? apiKey = freezed,
    Object? syncEmployees = null,
    Object? syncAttendance = null,
    Object? syncIntervalHours = null,
    Object? isActive = null,
    Object? lastSyncAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$HcmConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      apiEndpoint: freezed == apiEndpoint
          ? _value.apiEndpoint
          : apiEndpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      syncEmployees: null == syncEmployees
          ? _value.syncEmployees
          : syncEmployees // ignore: cast_nullable_to_non_nullable
              as bool,
      syncAttendance: null == syncAttendance
          ? _value.syncAttendance
          : syncAttendance // ignore: cast_nullable_to_non_nullable
              as bool,
      syncIntervalHours: null == syncIntervalHours
          ? _value.syncIntervalHours
          : syncIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncAt: freezed == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
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
class _$HcmConfigImpl implements _HcmConfig {
  const _$HcmConfigImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      required this.provider,
      @JsonKey(name: 'api_endpoint') this.apiEndpoint,
      @JsonKey(name: 'api_key') this.apiKey,
      @JsonKey(name: 'sync_employees') this.syncEmployees = true,
      @JsonKey(name: 'sync_attendance') this.syncAttendance = false,
      @JsonKey(name: 'sync_interval_hours') this.syncIntervalHours = 24,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'last_sync_at') this.lastSyncAt,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$HcmConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$HcmConfigImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  final String provider;
  @override
  @JsonKey(name: 'api_endpoint')
  final String? apiEndpoint;
  @override
  @JsonKey(name: 'api_key')
  final String? apiKey;
  @override
  @JsonKey(name: 'sync_employees')
  final bool syncEmployees;
  @override
  @JsonKey(name: 'sync_attendance')
  final bool syncAttendance;
  @override
  @JsonKey(name: 'sync_interval_hours')
  final int syncIntervalHours;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'last_sync_at')
  final String? lastSyncAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'HcmConfig(id: $id, companyId: $companyId, provider: $provider, apiEndpoint: $apiEndpoint, apiKey: $apiKey, syncEmployees: $syncEmployees, syncAttendance: $syncAttendance, syncIntervalHours: $syncIntervalHours, isActive: $isActive, lastSyncAt: $lastSyncAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HcmConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.apiEndpoint, apiEndpoint) ||
                other.apiEndpoint == apiEndpoint) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.syncEmployees, syncEmployees) ||
                other.syncEmployees == syncEmployees) &&
            (identical(other.syncAttendance, syncAttendance) ||
                other.syncAttendance == syncAttendance) &&
            (identical(other.syncIntervalHours, syncIntervalHours) ||
                other.syncIntervalHours == syncIntervalHours) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      provider,
      apiEndpoint,
      apiKey,
      syncEmployees,
      syncAttendance,
      syncIntervalHours,
      isActive,
      lastSyncAt,
      createdAt);

  /// Create a copy of HcmConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HcmConfigImplCopyWith<_$HcmConfigImpl> get copyWith =>
      __$$HcmConfigImplCopyWithImpl<_$HcmConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HcmConfigImplToJson(
      this,
    );
  }
}

abstract class _HcmConfig implements HcmConfig {
  const factory _HcmConfig(
      {required final String id,
      @JsonKey(name: 'company_id') required final String companyId,
      required final String provider,
      @JsonKey(name: 'api_endpoint') final String? apiEndpoint,
      @JsonKey(name: 'api_key') final String? apiKey,
      @JsonKey(name: 'sync_employees') final bool syncEmployees,
      @JsonKey(name: 'sync_attendance') final bool syncAttendance,
      @JsonKey(name: 'sync_interval_hours') final int syncIntervalHours,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'last_sync_at') final String? lastSyncAt,
      @JsonKey(name: 'created_at') final String? createdAt}) = _$HcmConfigImpl;

  factory _HcmConfig.fromJson(Map<String, dynamic> json) =
      _$HcmConfigImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  String get provider;
  @override
  @JsonKey(name: 'api_endpoint')
  String? get apiEndpoint;
  @override
  @JsonKey(name: 'api_key')
  String? get apiKey;
  @override
  @JsonKey(name: 'sync_employees')
  bool get syncEmployees;
  @override
  @JsonKey(name: 'sync_attendance')
  bool get syncAttendance;
  @override
  @JsonKey(name: 'sync_interval_hours')
  int get syncIntervalHours;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'last_sync_at')
  String? get lastSyncAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of HcmConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HcmConfigImplCopyWith<_$HcmConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
