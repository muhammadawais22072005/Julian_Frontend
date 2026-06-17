class AppointmentRequest {
  final String category;
  final String notes;

  AppointmentRequest({
    required this.category,
    required this.notes,
  });

  // This converts your Dart object to JSON for the POST request
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'notes': notes,
    };
  }
}