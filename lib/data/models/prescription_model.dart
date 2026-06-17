import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'prescription_model.freezed.dart';
part 'prescription_model.g.dart';


@freezed
class PrescriptionModel with _$PrescriptionModel {
  const factory PrescriptionModel({
    required String id,         // Database primary key
    required String drug,       // Medication name
    required String dosage,     // Strength (e.g., "500mg")
    required String frequency,  // How often (e.g., "Twice daily")
    required String duration,   // Treatment length
    required int refills,       // Remaining refills
    required DateTime date,     // Date prescribed
  }) = _PrescriptionModel;

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionModelFromJson(json);
}