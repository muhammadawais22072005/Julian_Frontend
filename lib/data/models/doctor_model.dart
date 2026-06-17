class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String experience;
  final int patients;
  final double rating;
  final int reviews;
  final String phone;
  final String email;
  final String location;
  final List<String> schedule; // e.g. ["Mon", "Tue", "Wed"]
  final String photo;
  final String bio;
  final int todayAppts;
  final bool available;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.patients,
    required this.rating,
    required this.reviews,
    required this.phone,
    required this.email,
    required this.location,
    required this.schedule,
    required this.photo,
    required this.bio,
    required this.todayAppts,
    required this.available,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      experience: json['experience'] as String,
      patients: json['patients'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      phone: json['phone'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
      schedule: List<String>.from(json['schedule'] ?? []),
      photo: json['photo'] as String,
      bio: json['bio'] as String,
      todayAppts: json['todayAppts'] as int,
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'experience': experience,
      'patients': patients,
      'rating': rating,
      'reviews': reviews,
      'phone': phone,
      'email': email,
      'location': location,
      'schedule': schedule,
      'photo': photo,
      'bio': bio,
      'todayAppts': todayAppts,
      'available': available,
    };
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? experience,
    int? patients,
    double? rating,
    int? reviews,
    String? phone,
    String? email,
    String? location,
    List<String>? schedule,
    String? photo,
    String? bio,
    int? todayAppts,
    bool? available,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      experience: experience ?? this.experience,
      patients: patients ?? this.patients,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      schedule: schedule ?? this.schedule,
      photo: photo ?? this.photo,
      bio: bio ?? this.bio,
      todayAppts: todayAppts ?? this.todayAppts,
      available: available ?? this.available,
    );
  }
}
