// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ncns.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NcnsLog _$NcnsLogFromJson(Map<String, dynamic> json) {
  return _NcnsLog.fromJson(json);
}

/// @nodoc
mixin _$NcnsLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id')
  String get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'marked_by')
  String? get markedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NcnsLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NcnsLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NcnsLogCopyWith<NcnsLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NcnsLogCopyWith<$Res> {
  factory $NcnsLogCopyWith(NcnsLog value, $Res Function(NcnsLog) then) =
      _$NcnsLogCopyWithImpl<$Res, NcnsLog>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'company_id') String companyId,
      String? date,
      String? reason,
      @JsonKey(name: 'marked_by') String? markedBy,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$NcnsLogCopyWithImpl<$Res, $Val extends NcnsLog>
    implements $NcnsLogCopyWith<$Res> {
  _$NcnsLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NcnsLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? date = freezed,
    Object? reason = freezed,
    Object? markedBy = freezed,
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
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      markedBy: freezed == markedBy
          ? _value.markedBy
          : markedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NcnsLogImplCopyWith<$Res> implements $NcnsLogCopyWith<$Res> {
  factory _$$NcnsLogImplCopyWith(
          _$NcnsLogImpl value, $Res Function(_$NcnsLogImpl) then) =
      __$$NcnsLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'company_id') String companyId,
      String? date,
      String? reason,
      @JsonKey(name: 'marked_by') String? markedBy,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$NcnsLogImplCopyWithImpl<$Res>
    extends _$NcnsLogCopyWithImpl<$Res, _$NcnsLogImpl>
    implements _$$NcnsLogImplCopyWith<$Res> {
  __$$NcnsLogImplCopyWithImpl(
      _$NcnsLogImpl _value, $Res Function(_$NcnsLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of NcnsLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? companyId = null,
    Object? date = freezed,
    Object? reason = freezed,
    Object? markedBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$NcnsLogImpl(
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
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      markedBy: freezed == markedBy
          ? _value.markedBy
          : markedBy // ignore: cast_nullable_to_non_nullable
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
class _$NcnsLogImpl implements _NcnsLog {
  const _$NcnsLogImpl(
      {required this.id,
      @JsonKey(name: 'employee_id') required this.employeeId,
      @JsonKey(name: 'company_id') required this.companyId,
      this.date,
      this.reason,
      @JsonKey(name: 'marked_by') this.markedBy,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$NcnsLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$NcnsLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'employee_id')
  final String employeeId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  final String? date;
  @override
  final String? reason;
  @override
  @JsonKey(name: 'marked_by')
  final String? markedBy;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'NcnsLog(id: $id, employeeId: $employeeId, companyId: $companyId, date: $date, reason: $reason, markedBy: $markedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NcnsLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.markedBy, markedBy) ||
                other.markedBy == markedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, employeeId, companyId, date,
      reason, markedBy, createdAt);

  /// Create a copy of NcnsLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NcnsLogImplCopyWith<_$NcnsLogImpl> get copyWith =>
      __$$NcnsLogImplCopyWithImpl<_$NcnsLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NcnsLogImplToJson(
      this,
    );
  }
}

abstract class _NcnsLog implements NcnsLog {
  const factory _NcnsLog(
      {required final String id,
      @JsonKey(name: 'employee_id') required final String employeeId,
      @JsonKey(name: 'company_id') required final String companyId,
      final String? date,
      final String? reason,
      @JsonKey(name: 'marked_by') final String? markedBy,
      @JsonKey(name: 'created_at') final String? createdAt}) = _$NcnsLogImpl;

  factory _NcnsLog.fromJson(Map<String, dynamic> json) = _$NcnsLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'employee_id')
  String get employeeId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  String? get date;
  @override
  String? get reason;
  @override
  @JsonKey(name: 'marked_by')
  String? get markedBy;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of NcnsLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NcnsLogImplCopyWith<_$NcnsLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NcnsSettings _$NcnsSettingsFromJson(Map<String, dynamic> json) {
  return _NcnsSettings.fromJson(json);
}

/// @nodoc
mixin _$NcnsSettings {
  @JsonKey(name: 'ncns_threshold')
  int get ncnsThreshold => throw _privateConstructorUsedError;
  @JsonKey(name: 'auto_disable')
  bool get autoDisable => throw _privateConstructorUsedError;

  /// Serializes this NcnsSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NcnsSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NcnsSettingsCopyWith<NcnsSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NcnsSettingsCopyWith<$Res> {
  factory $NcnsSettingsCopyWith(
          NcnsSettings value, $Res Function(NcnsSettings) then) =
      _$NcnsSettingsCopyWithImpl<$Res, NcnsSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ncns_threshold') int ncnsThreshold,
      @JsonKey(name: 'auto_disable') bool autoDisable});
}

/// @nodoc
class _$NcnsSettingsCopyWithImpl<$Res, $Val extends NcnsSettings>
    implements $NcnsSettingsCopyWith<$Res> {
  _$NcnsSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NcnsSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ncnsThreshold = null,
    Object? autoDisable = null,
  }) {
    return _then(_value.copyWith(
      ncnsThreshold: null == ncnsThreshold
          ? _value.ncnsThreshold
          : ncnsThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      autoDisable: null == autoDisable
          ? _value.autoDisable
          : autoDisable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NcnsSettingsImplCopyWith<$Res>
    implements $NcnsSettingsCopyWith<$Res> {
  factory _$$NcnsSettingsImplCopyWith(
          _$NcnsSettingsImpl value, $Res Function(_$NcnsSettingsImpl) then) =
      __$$NcnsSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ncns_threshold') int ncnsThreshold,
      @JsonKey(name: 'auto_disable') bool autoDisable});
}

/// @nodoc
class __$$NcnsSettingsImplCopyWithImpl<$Res>
    extends _$NcnsSettingsCopyWithImpl<$Res, _$NcnsSettingsImpl>
    implements _$$NcnsSettingsImplCopyWith<$Res> {
  __$$NcnsSettingsImplCopyWithImpl(
      _$NcnsSettingsImpl _value, $Res Function(_$NcnsSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NcnsSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ncnsThreshold = null,
    Object? autoDisable = null,
  }) {
    return _then(_$NcnsSettingsImpl(
      ncnsThreshold: null == ncnsThreshold
          ? _value.ncnsThreshold
          : ncnsThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      autoDisable: null == autoDisable
          ? _value.autoDisable
          : autoDisable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NcnsSettingsImpl implements _NcnsSettings {
  const _$NcnsSettingsImpl(
      {@JsonKey(name: 'ncns_threshold') this.ncnsThreshold = 3,
      @JsonKey(name: 'auto_disable') this.autoDisable = true});

  factory _$NcnsSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NcnsSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'ncns_threshold')
  final int ncnsThreshold;
  @override
  @JsonKey(name: 'auto_disable')
  final bool autoDisable;

  @override
  String toString() {
    return 'NcnsSettings(ncnsThreshold: $ncnsThreshold, autoDisable: $autoDisable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NcnsSettingsImpl &&
            (identical(other.ncnsThreshold, ncnsThreshold) ||
                other.ncnsThreshold == ncnsThreshold) &&
            (identical(other.autoDisable, autoDisable) ||
                other.autoDisable == autoDisable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ncnsThreshold, autoDisable);

  /// Create a copy of NcnsSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NcnsSettingsImplCopyWith<_$NcnsSettingsImpl> get copyWith =>
      __$$NcnsSettingsImplCopyWithImpl<_$NcnsSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NcnsSettingsImplToJson(
      this,
    );
  }
}

abstract class _NcnsSettings implements NcnsSettings {
  const factory _NcnsSettings(
          {@JsonKey(name: 'ncns_threshold') final int ncnsThreshold,
          @JsonKey(name: 'auto_disable') final bool autoDisable}) =
      _$NcnsSettingsImpl;

  factory _NcnsSettings.fromJson(Map<String, dynamic> json) =
      _$NcnsSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'ncns_threshold')
  int get ncnsThreshold;
  @override
  @JsonKey(name: 'auto_disable')
  bool get autoDisable;

  /// Create a copy of NcnsSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NcnsSettingsImplCopyWith<_$NcnsSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
