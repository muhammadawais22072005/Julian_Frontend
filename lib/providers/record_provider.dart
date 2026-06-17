import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:julian_medical_center/data/models/medical_record_model.dart';
// Added missing model import for the prescriptions data constructor structure
import 'package:julian_medical_center/data/models/prescription_model.dart';
import 'package:julian_medical_center/providers/auth_provider.dart'; // Contains apiRepositoryProvider

// ─── MEDICAL RECORDS ASYNC ENGINE ───────────────────────────────────────────
class MedicalRecordListNotifier extends AutoDisposeAsyncNotifier<List<MedicalRecordModel>> {
  @override
  Future<List<MedicalRecordModel>> build() async {
    final repository = ref.watch(apiRepositoryProvider);
    return await repository.getMedicalRecords();
  }

  Future<void> refresh() async {
    final previousState = state;
    state = AsyncLoading<List<MedicalRecordModel>>().copyWithPrevious(previousState);
    try {
      final repository = ref.read(apiRepositoryProvider);
      final list = await repository.getMedicalRecords();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue<List<MedicalRecordModel>>.error(e, stack).copyWithPrevious(previousState);
    }
  }
}

final medicalRecordListProvider =
AutoDisposeAsyncNotifierProvider<MedicalRecordListNotifier, List<MedicalRecordModel>>(
  MedicalRecordListNotifier.new,
);

// ─── PRESCRIPTIONS LIST ASYNC ENGINE ─────────────────────────────────────────
class PrescriptionListNotifier extends AutoDisposeAsyncNotifier<List<PrescriptionModel>> {
  @override
  Future<List<PrescriptionModel>> build() async {
    final repository = ref.watch(apiRepositoryProvider);
    return await repository.getPrescriptions();
  }

  Future<void> refresh() async {
    final previousState = state;
    state = AsyncLoading<List<PrescriptionModel>>().copyWithPrevious(previousState);
    try {
      final repository = ref.read(apiRepositoryProvider);
      final list = await repository.getPrescriptions();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue<List<PrescriptionModel>>.error(e, stack).copyWithPrevious(previousState);
    }
  }
}

final prescriptionListProvider =
AutoDisposeAsyncNotifierProvider<PrescriptionListNotifier, List<PrescriptionModel>>(
  PrescriptionListNotifier.new,
);

// ─── SEARCH & FILTER INPUT REACTIVE SLICES ───────────────────────────────────
final recordSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final recordCategoryFilterProvider = StateProvider.autoDispose<String>((ref) => 'All');

// ─── FLAT FILTERED SELECTOR PIPELINE ─────────────────────────────────────────
final filteredRecordsProvider =
Provider.autoDispose<AsyncValue<List<MedicalRecordModel>>>((ref) {
  final recordsAsync = ref.watch(medicalRecordListProvider);
  final query = ref.watch(recordSearchQueryProvider).trim().toLowerCase();
  final category = ref.watch(recordCategoryFilterProvider);

  return recordsAsync.when(
    loading: () => const AsyncValue.loading(),

    error: (e, s) => AsyncValue.error(e, s),

    data: (records) {
      final filtered = records.where((r) {
        final matchesQuery = query.isEmpty ||
            r.patient.toLowerCase().contains(query) ||
            r.type.toLowerCase().contains(query) ||
            r.id.toLowerCase().contains(query);

        final matchesCategory = category == 'All' ||
            r.category.toLowerCase() == category.toLowerCase();

        return matchesQuery && matchesCategory;
      }).toList();

      return AsyncValue.data(filtered);
    },
  );
});