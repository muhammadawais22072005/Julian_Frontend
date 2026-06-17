class MedicalRecordModel {
  final String id;
  final String patient;
  final String type;
  final String date;
  final String doctor;
  final String size;
  final String status; // 'reviewed', 'pending'
  final String category; // 'lab', 'report', 'imaging'
  final String? description;

  MedicalRecordModel({
    required this.id,
    required this.patient,
    required this.type,
    required this.date,
    required this.doctor,
    required this.size,
    required this.status,
    required this.category,
    this.description,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as String,
      patient: json['patient'] as String,
      type: json['type'] as String,
      date: json['date'] as String,
      doctor: json['doctor'] as String,
      size: json['size'] as String,
      status: json['status'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient,
      'type': type,
      'date': date,
      'doctor': doctor,
      'size': size,
      'status': status,
      'category': category,
      'description': description,
    };
  }
}

class RecordPrescriptionModel {
  final String patient;
  final String drug;
  final String dosage;
  final String duration;
  final String prescribed;
  final int refills;

  RecordPrescriptionModel({
    required this.patient,
    required this.drug,
    required this.dosage,
    required this.duration,
    required this.prescribed,
    required this.refills,
  });

  factory RecordPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return RecordPrescriptionModel(
      patient: json['patient'] as String,
      drug: json['drug'] as String,
      dosage: json['dosage'] as String,
      duration: json['duration'] as String,
      prescribed: json['prescribed'] as String,
      refills: json['refills'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient': patient,
      'drug': drug,
      'dosage': dosage,
      'duration': duration,
      'prescribed': prescribed,
      'refills': refills,
    };
  }
}
