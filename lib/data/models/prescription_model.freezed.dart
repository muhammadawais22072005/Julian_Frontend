// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrescriptionModel _$PrescriptionModelFromJson(Map<String, dynamic> json) {
  return _PrescriptionModel.fromJson(json);
}

/// @nodoc
mixin _$PrescriptionModel {
  String get id => throw _privateConstructorUsedError; // Database primary key
  String get drug => throw _privateConstructorUsedError; // Medication name
  String get dosage =>
      throw _privateConstructorUsedError; // Strength (e.g., "500mg")
  String get frequency =>
      throw _privateConstructorUsedError; // How often (e.g., "Twice daily")
  String get duration => throw _privateConstructorUsedError; // Treatment length
  int get refills => throw _privateConstructorUsedError; // Remaining refills
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this PrescriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionModelCopyWith<PrescriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionModelCopyWith<$Res> {
  factory $PrescriptionModelCopyWith(
          PrescriptionModel value, $Res Function(PrescriptionModel) then) =
      _$PrescriptionModelCopyWithImpl<$Res, PrescriptionModel>;
  @useResult
  $Res call(
      {String id,
      String drug,
      String dosage,
      String frequency,
      String duration,
      int refills,
      DateTime date});
}

/// @nodoc
class _$PrescriptionModelCopyWithImpl<$Res, $Val extends PrescriptionModel>
    implements $PrescriptionModelCopyWith<$Res> {
  _$PrescriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drug = null,
    Object? dosage = null,
    Object? frequency = null,
    Object? duration = null,
    Object? refills = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      drug: null == drug
          ? _value.drug
          : drug // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      refills: null == refills
          ? _value.refills
          : refills // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrescriptionModelImplCopyWith<$Res>
    implements $PrescriptionModelCopyWith<$Res> {
  factory _$$PrescriptionModelImplCopyWith(_$PrescriptionModelImpl value,
          $Res Function(_$PrescriptionModelImpl) then) =
      __$$PrescriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String drug,
      String dosage,
      String frequency,
      String duration,
      int refills,
      DateTime date});
}

/// @nodoc
class __$$PrescriptionModelImplCopyWithImpl<$Res>
    extends _$PrescriptionModelCopyWithImpl<$Res, _$PrescriptionModelImpl>
    implements _$$PrescriptionModelImplCopyWith<$Res> {
  __$$PrescriptionModelImplCopyWithImpl(_$PrescriptionModelImpl _value,
      $Res Function(_$PrescriptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrescriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drug = null,
    Object? dosage = null,
    Object? frequency = null,
    Object? duration = null,
    Object? refills = null,
    Object? date = null,
  }) {
    return _then(_$PrescriptionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      drug: null == drug
          ? _value.drug
          : drug // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      refills: null == refills
          ? _value.refills
          : refills // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrescriptionModelImpl implements _PrescriptionModel {
  const _$PrescriptionModelImpl(
      {required this.id,
      required this.drug,
      required this.dosage,
      required this.frequency,
      required this.duration,
      required this.refills,
      required this.date});

  factory _$PrescriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrescriptionModelImplFromJson(json);

  @override
  final String id;
// Database primary key
  @override
  final String drug;
// Medication name
  @override
  final String dosage;
// Strength (e.g., "500mg")
  @override
  final String frequency;
// How often (e.g., "Twice daily")
  @override
  final String duration;
// Treatment length
  @override
  final int refills;
// Remaining refills
  @override
  final DateTime date;

  @override
  String toString() {
    return 'PrescriptionModel(id: $id, drug: $drug, dosage: $dosage, frequency: $frequency, duration: $duration, refills: $refills, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.drug, drug) || other.drug == drug) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.refills, refills) || other.refills == refills) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, drug, dosage, frequency, duration, refills, date);

  /// Create a copy of PrescriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionModelImplCopyWith<_$PrescriptionModelImpl> get copyWith =>
      __$$PrescriptionModelImplCopyWithImpl<_$PrescriptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrescriptionModelImplToJson(
      this,
    );
  }
}

abstract class _PrescriptionModel implements PrescriptionModel {
  const factory _PrescriptionModel(
      {required final String id,
      required final String drug,
      required final String dosage,
      required final String frequency,
      required final String duration,
      required final int refills,
      required final DateTime date}) = _$PrescriptionModelImpl;

  factory _PrescriptionModel.fromJson(Map<String, dynamic> json) =
      _$PrescriptionModelImpl.fromJson;

  @override
  String get id; // Database primary key
  @override
  String get drug; // Medication name
  @override
  String get dosage; // Strength (e.g., "500mg")
  @override
  String get frequency; // How often (e.g., "Twice daily")
  @override
  String get duration; // Treatment length
  @override
  int get refills; // Remaining refills
  @override
  DateTime get date;

  /// Create a copy of PrescriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionModelImplCopyWith<_$PrescriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
