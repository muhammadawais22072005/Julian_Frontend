class AppointmentModel {
  final int id;
  final int? userId;
  final String category;
  final bool? isAvailable;
  final String? patient;
  final String? doctor;
  final String? type;
  final String? date;
  final DateTime? createdAt;
  final String appointmentStatus;
  final String? department;
  final String? cancellationReason;

  AppointmentModel({
    required this.id,
    this.userId,
    required this.category,
    this.isAvailable,
    this.patient,
    this.doctor,
    this.type,
    this.date,
    this.createdAt,
    required this.appointmentStatus,
    this.department,
    this.cancellationReason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      category: json['category'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool?,
      patient: json['patient'] as String?,
      doctor: json['doctor'] as String?,
      type: json['type'] as String?,
      date: json['date'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      appointmentStatus: json['appointmentStatus']?.toString() ?? '',
      department: json['department'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'isAvailable': isAvailable,
      'patient': patient,
      'doctor': doctor,
      'type': type,
      'date': date,
      'createdAt': createdAt?.toIso8601String(),
      'appointmentStatus': appointmentStatus,
      'department': department,
      'cancellationReason': cancellationReason,
    };
  }

  AppointmentModel copyWith({
    int? id,
    int? userId,
    String? category,
    bool? isAvailable,
    String? patient,
    String? doctor,
    String? type,
    String? date,
    DateTime? createdAt,
    String? appointmentStatus,
    String? department,
    String? cancellationReason,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      type: type ?? this.type,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      department: department ?? this.department,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}