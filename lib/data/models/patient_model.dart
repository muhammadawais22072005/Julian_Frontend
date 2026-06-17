class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final DateTime dob; // Updated to DateTime
  final String phone;
  final String email;
  final String bloodType;
  final DateTime lastVisit; // Updated to DateTime
  final String condition;
  final String doctor;
  final String status;
  final List<int> heartRateHistory;
  final List<String> bloodPressureHistory;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.email,
    required this.bloodType,
    required this.lastVisit,
    required this.condition,
    required this.doctor,
    required this.status,
    required this.heartRateHistory,
    required this.bloodPressureHistory,
  });

  // Factory to create model from API JSON
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      dob: DateTime.tryParse(json['dob']?.toString() ?? '') ?? DateTime.now(),
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bloodType: json['bloodType'] as String? ?? '',
      lastVisit: DateTime.tryParse(json['lastVisit']?.toString() ?? '') ?? DateTime.now(),
      condition: json['condition'] as String? ?? '',
      doctor: json['doctor'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      heartRateHistory: List<int>.from(json['heartRateHistory'] ?? []),
      bloodPressureHistory: List<String>.from(json['bloodPressureHistory'] ?? []),
    );
  }

  // Method to send model back to API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'phone': phone,
      'email': email,
      'bloodType': bloodType,
      'lastVisit': lastVisit.toIso8601String(),
      'condition': condition,
      'doctor': doctor,
      'status': status,
      'heartRateHistory': heartRateHistory,
      'bloodPressureHistory': bloodPressureHistory,
    };
  }

  // copyWith for state management (useful for Riverpod)
  PatientModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    DateTime? dob,
    String? phone,
    String? email,
    String? bloodType,
    DateTime? lastVisit,
    String? condition,
    String? doctor,
    String? status,
    List<int>? heartRateHistory,
    List<String>? bloodPressureHistory,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bloodType: bloodType ?? this.bloodType,
      lastVisit: lastVisit ?? this.lastVisit,
      condition: condition ?? this.condition,
      doctor: doctor ?? this.doctor,
      status: status ?? this.status,
      heartRateHistory: heartRateHistory ?? this.heartRateHistory,
      bloodPressureHistory: bloodPressureHistory ?? this.bloodPressureHistory,
    );
  }
}