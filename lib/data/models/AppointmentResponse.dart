class AppointmentResponse {
  final int id;
  final String category;
  final String appointmentStatus; // Mapping Java Enum to String
  final bool? isAvailable;
  final int? userId;
  final String? notes;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppointmentResponse({
    required this.id,
    required this.category,
    required this.appointmentStatus,
    this.isAvailable,
    this.userId,
    this.notes,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      id: (json['id'] as num).toInt(),
      category: json['category'] as String,
      appointmentStatus: json['appointmentStatus'] as String,
      isAvailable: json['isAvailable'] as bool?,
      userId: json['userId'] != null ? (json['userId'] as num).toInt() : null,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}