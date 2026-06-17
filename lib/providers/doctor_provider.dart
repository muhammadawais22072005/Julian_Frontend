import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:julian_medical_center/data/models/doctor_model.dart';
import 'package:julian_medical_center/providers/auth_provider.dart'; // Contains apiRepositoryProvider

// ─── DOCTOR ROSTER ASYNC ENGINE ──────────────────────────────────────────────
class DoctorListNotifier extends AutoDisposeAsyncNotifier<List<DoctorModel>> {
  @override
  Future<List<DoctorModel>> build() async {
    // Swapped to watch to safely re-establish data bindings if service rules update
    final repository = ref.watch(apiRepositoryProvider);
    return await repository.getDoctors();
  }

  // ─── MUTATION: BACKGROUND REFRESH ──────────────────────────────────────────
  Future<void> refresh() async {
    final previousState = state;
    // Uses copyWithPrevious to keep the old data visible during the reload process
    state = AsyncLoading<List<DoctorModel>>().copyWithPrevious(previousState);

    try {
      final repository = ref.read(apiRepositoryProvider);
      final list = await repository.getDoctors();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue<List<DoctorModel>>.error(e, stack).copyWithPrevious(previousState);
    }
  }
}

// Global hook with matched Riverpod 2.x typing signatures
final doctorListProvider =
AutoDisposeAsyncNotifierProvider<DoctorListNotifier, List<DoctorModel>>(
  DoctorListNotifier.new,
);

// ─── FILTER CONTROL STATE PROVIDER ───────────────────────────────────────────
final doctorSpecialtyFilterProvider = StateProvider.autoDispose<String>((ref) => 'All');

// ─── THE FILTERED DATA PIPELINE (CLEANED EXPLICIT TYPE GRAPH) ─────────────────
// By omitting <AsyncValue<...>> and using the .whenData map directly, Riverpod
// automatically converts this provider's output type to an un-nested AsyncValue<List<DoctorModel>>.
final filteredDoctorsProvider = Provider.autoDispose<List<DoctorModel>>((ref) {
  final doctorsAsync = ref.watch(doctorListProvider);
  final specialtyFilter = ref.watch(doctorSpecialtyFilterProvider);

  // Directly mapping inside whenData resolves downstream widget complexity
  return doctorsAsync.maybeWhen(
    data: (doctors) {
      if (specialtyFilter == 'All' || specialtyFilter.isEmpty) {
        return doctors;
      }
      return doctors
          .where((d) => d.specialty.toLowerCase() == specialtyFilter.toLowerCase())
          .toList();
    },
    // Fallback structure returns an empty array placeholder safely if not initialized yet
    orElse: () => <DoctorModel>[],
  );
});