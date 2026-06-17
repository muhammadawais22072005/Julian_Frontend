// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrescriptionModelImpl _$$PrescriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PrescriptionModelImpl(
      id: json['id'] as String,
      drug: json['drug'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as String,
      refills: (json['refills'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$PrescriptionModelImplToJson(
        _$PrescriptionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'drug': instance.drug,
      'dosage': instance.dosage,
      'frequency': instance.frequency,
      'duration': instance.duration,
      'refills': instance.refills,
      'date': instance.date.toIso8601String(),
    };
