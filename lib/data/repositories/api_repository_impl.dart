import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import 'package:julian_medical_center/data/models/ChangePassword.dart';
import 'package:julian_medical_center/data/models/UserResponse.dart';
import 'package:julian_medical_center/data/models/userRequest.dart';
import 'package:julian_medical_center/data/models/user_model.dart';
import 'package:julian_medical_center/data/models/patient_model.dart';
import 'package:julian_medical_center/data/models/doctor_model.dart';
import 'package:julian_medical_center/data/models/appointment_model.dart';
import 'package:julian_medical_center/data/models/medical_record_model.dart';
import 'package:julian_medical_center/data/models/prescription_model.dart';
import 'package:julian_medical_center/data/services/api_service.dart';
import '../models/appointment_request.dart';
import 'api_repository.dart';
import 'package:julian_medical_center/data/services/api_service.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiService _apiService;
  final bool _preferMocks;
  // ─── FORGOT PASSWORD FLOW ──────────────────────────────────────────────────

  @override
  Future<void> sendOtp(String email) async {
    // Matches: @PostMapping("/verifyMail/{email}")
    await _apiService.post('/forgotPassword/verifyMail/$email');
  }

  @override
  Future<void> verifyOtp(String email, int otp) async {
    // Matches: @PostMapping("/verifyOtp/{otp}/{email}")
    await _apiService.post('/forgotPassword/verifyOtp/$otp/$email');
  }

  @override
  Future<void> changePassword(String email, String password, String repeatPassword) async {
    // Matches: @PostMapping("/changePassword/{email}")
    // Uses the ChangePassword DTO we defined earlier
    final request = ChangePassword(password: password, repeatPassword: repeatPassword);

    await _apiService.post(
        '/forgotPassword/changePassword/$email',
        data: request.toJson()
    );
  }

  ApiRepositoryImpl(this._apiService, {bool preferMocks = true})
      : _preferMocks = preferMocks;

  @override
  Future<List<UserResponse>> getAllUsers() async {
    final response = await _apiService.get('/api/users');

    // Ensure response.data is treated as a List of Maps
    final List<dynamic> data = response.data;

    // Map each element 'e' to the UserResponse model
    return data.map((e) => UserResponse.fromJson(e)).toList();
  }

  // POST /api/users/signup
  @override
  Future<void> registerUser(UserRequest request) async {
    await _apiService.post('/api/users/signup', data: request.toJson());
  }

  // DELETE /api/users/{id}
  @override
  Future<void> deactivateUser(int id) async {
    await _apiService.delete('/api/users/$id');
  }

  // POST /api/users/promote/{id}
  @override
  Future<void> promoteUser(int id) async {
    await _apiService.post('/api/users/promote/$id');
  }
  @override
  Future<void> createAppointment(AppointmentRequest request) async {
    final response = await _apiService.post('/appointments/create', data: request.toJson());
    if (response.statusCode != 200) throw Exception("Failed to create appointment");
  }

  @override
  Future<List<AppointmentModel>> getAllAppointments() async {
    final response = await _apiService.get('/appointments');
    return (response.data as List).map((e) => AppointmentModel.fromJson(e)).toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(int id) async {
    final response = await _apiService.get('/appointments/id/$id');
    return AppointmentModel.fromJson(response.data);
  }

  // ─── AUTHENTICATION ────────────────────────────────────────────────────────
  @override
  Future<UserModel> signIn(String email, String password) async {
    if (_preferMocks) {
      return _mockSignInLogic(email, password);
    }

    try {
      final response = await _apiService.post('/auth/signin', data: {
        'email': email,
        'password': password,
      });
      return UserModel.fromJson(response.data);
    } catch (e) {
      if (e.toString().contains('connection') || e.toString().contains('Failed to connect')) {
        return _mockSignInLogic(email, password);
      }
      rethrow;
    }
  }

  Future<UserModel> _mockSignInLogic(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email == 'admin@julianmedical.com' && password == 'Admin@2026') {
      return UserModel(
        id: 'admin-id-1',
        email: email,
        fullName: 'System Admin',
        role: 'admin',
        token: 'mock-jwt-token-admin',
      );
    } else if (email.contains('@') && password.length >= 6) {
      return UserModel(
        id: 'patient-id-1',
        email: email,
        fullName: email.split('@').first.toUpperCase(),
        role: 'patient',
        token: 'mock-jwt-token-patient',
      );
    } else {
      throw Exception('Invalid email or password. Use admin@julianmedical.com / Admin@2026');
    }
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 800));
      return UserModel(
        id: 'new-patient-id',
        email: email,
        fullName: fullName,
        role: 'patient',
        token: 'mock-jwt-token-new',
      );
    }

    try {
      final response = await _apiService.post('/auth/signup', data: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      });
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // ─── PATIENTS ──────────────────────────────────────────────────────────────
  @override
  Future<List<PatientModel>> getPatients() async {
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockPatients;
    }

    try {
      final response = await _apiService.get('/patients');
      final list = response.data as List;
      return list.map((p) => PatientModel.fromJson(p)).toList();
    } catch (e) {
      return _mockPatients;
    }
  }

  @override
  Future<Map<String, dynamic>> getPatientVitals(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Added a fallback check to prevent crashes if mock lists are empty
    if (_mockPatients.isEmpty) {
      return {
        'currentHeartRate': 72,
        'heartRateHistory': [72],
        'currentBloodPressure': '120/80',
        'bloodPressureHistory': ['120/80'],
      };
    }

    final patient = _mockPatients.firstWhere(
          (p) => p.id == patientId,
      orElse: () => _mockPatients.first,
    );
    return {
      'currentHeartRate': patient.heartRateHistory.last,
      'heartRateHistory': patient.heartRateHistory,
      'currentBloodPressure': patient.bloodPressureHistory.last,
      'bloodPressureHistory': patient.bloodPressureHistory,
    };
  }

  // ─── DOCTORS ────────────────────────────────────────────────────────────────
  @override
  Future<List<DoctorModel>> getDoctors() async {
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockDoctors;
    }

    try {
      final response = await _apiService.get('/doctors');
      final list = response.data as List;
      return list.map((d) => DoctorModel.fromJson(d)).toList();
    } catch (e) {
      return _mockDoctors;
    }
  }

  // ─── APPOINTMENTS ───────────────────────────────────────────────────────────
  // ─── APPOINTMENTS ───────────────────────────────────────────────────────────
  @override
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    // 1. If mocks are enabled, return mock data
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 1000));
      final newId = 1000 + _mockAppointments.length;
      final newAppt = appointment.copyWith(id: newId);
      _mockAppointments.add(newAppt);
      return newAppt;
    }

    // 2. If not using mocks, perform the real API call
    try {
      // I kept your _apiService style for consistency with the rest of your file
      final response = await _apiService.post('/appointments/create', data: appointment.toJson());
      return AppointmentModel.fromJson(response.data);
    } catch (e) {
      // If the real API fails, you can decide to throw the error
      // or fall back to local mock storage
      throw Exception('Failed to book appointment: $e');
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockAppointments;
    }

    try {
      final response = await _apiService.get('/appointments');
      final list = response.data as List;
      return list.map((a) => AppointmentModel.fromJson(a)).toList();
    } catch (e) {
      return _mockAppointments;
    }
  }

  // ─── MEDICAL RECORDS ────────────────────────────────────────────────────────
  @override
  Future<List<MedicalRecordModel>> getMedicalRecords() async {
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockRecords;
    }

    try {
      final response = await _apiService.get('/records');
      final list = response.data as List;
      return list.map((r) => MedicalRecordModel.fromJson(r)).toList();
    } catch (e) {
      return _mockRecords;
    }
  }

  @override
  Future<List<PrescriptionModel>> getPrescriptions() async {
    if (_preferMocks) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockPrescriptions;
    }

    try {
      final response = await _apiService.get('/prescriptions');
      final list = response.data as List;
      return list.map((p) => PrescriptionModel.fromJson(p)).toList();
    } catch (e) {
      return _mockPrescriptions;
    }
  }


} // Class closes properly here

// ─── HIGH-FIDELITY MOCK DATA STORES ──────────────────────────────────────────
final List<PatientModel> _mockPatients = [];
final List<DoctorModel> _mockDoctors = [];
final List<AppointmentModel> _mockAppointments = [];
final List<MedicalRecordModel> _mockRecords = [];
final List<PrescriptionModel> _mockPrescriptions = [];

// ─── RIVERPOD PROVIDERS ──────────────────────────────────────────────────────
// This prevents errors if you haven't defined apiServiceProvider yet:
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ApiRepositoryImpl(apiService, preferMocks: true);
});
