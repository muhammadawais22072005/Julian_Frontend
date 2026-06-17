import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:julian_medical_center/data/models/patient_model.dart';
import 'package:julian_medical_center/providers/auth_provider.dart'; // Contains apiRepositoryProvider

// ─── PATIENT ROSTER ASYNC STATE ENGINE ───────────────────────────────────────
class PatientListNotifier extends AutoDisposeAsyncNotifier<List<PatientModel>> {
  @override
  Future<List<PatientModel>> build() async {
    // Swapped to watch to safely re-establish reactive data bindings if the API repository state graph updates
    final repository = ref.watch(apiRepositoryProvider);
    return await repository.getPatients();
  }

  // ─── MUTATION: BACKGROUND CACHE REFRESH ────────────────────────────────────
  Future<void> refresh() async {
    final previousState = state;
    // Uses copyWithPrevious to keep the old roster visible on-screen during the fetch operation
    state = AsyncLoading<List<PatientModel>>().copyWithPrevious(previousState);

    try {
      final repository = ref.read(apiRepositoryProvider);
      final list = await repository.getPatients();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue<List<PatientModel>>.error(e, stack).copyWithPrevious(previousState);
    }
  }
}

// Global initialization hook with matched Riverpod 2.x typing signatures
final patientListProvider =
AutoDisposeAsyncNotifierProvider<PatientListNotifier, List<PatientModel>>(
  PatientListNotifier.new,
);

// ─── SELECTED PATIENT CONTROL STATE PROVIDER ─────────────────────────────────
final selectedPatientProvider = StateProvider.autoDispose<PatientModel?>((ref) => null);

// ─── LIVE CLINICAL VITALS TRACKING (FAMILY PIPELINE) ─────────────────────────
// Cleaned up the ref reference structure inside the asynchronous call context
final patientVitalsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, patientId) async {
  final repository = ref.watch(apiRepositoryProvider);
  return await repository.getPatientVitals(patientId);
});