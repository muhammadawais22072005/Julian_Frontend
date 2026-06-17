import 'package:julian_medical_center/data/models/UserResponse.dart';
import 'package:julian_medical_center/data/models/appointment_request.dart';
import 'package:julian_medical_center/data/models/userRequest.dart';
import 'package:julian_medical_center/data/models/user_model.dart';
import 'package:julian_medical_center/data/models/patient_model.dart';
import 'package:julian_medical_center/data/models/doctor_model.dart';
import 'package:julian_medical_center/data/models/appointment_model.dart';
import 'package:julian_medical_center/data/models/medical_record_model.dart';
import 'package:julian_medical_center/data/models/prescription_model.dart';

abstract class ApiRepository {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> signOut();
  Future<void> promoteUser(int id);
  Future<void> deactivateUser(int id);
  Future<void> registerUser(UserRequest request);
  Future<List<UserResponse>> getAllUsers();
  Future<List<PatientModel>> getPatients();
  Future<Map<String, dynamic>> getPatientVitals(String patientId);
  Future<List<DoctorModel>> getDoctors();
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment);
  Future<List<AppointmentModel>> getAppointments();
  Future<List<MedicalRecordModel>> getMedicalRecords();
  Future<List<PrescriptionModel>> getPrescriptions();
  Future<void> createAppointment(AppointmentRequest request);
  Future<List<AppointmentModel>> getAllAppointments();
  Future<AppointmentModel> getAppointmentById(int id);
  Future<void> sendOtp(String email);
  Future<void> verifyOtp(String email, int otp);
  Future<void> changePassword(String email, String password, String repeatPassword);
}