import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:julian_medical_center/data/models/appointment_model.dart';
import 'package:julian_medical_center/providers/auth_provider.dart'; // Contains apiRepositoryProvider

// ─── APPOINTMENT LIST NOTIFIER ───────────────────────────────────────────────
class AppointmentListNotifier extends AutoDisposeAsyncNotifier<List<AppointmentModel>> {

  @override
  Future<List<AppointmentModel>> build() async {
    // Standard practice uses ref.watch inside build() to automatically re-evaluate
    // if underlying global state rules (like the API client base URL) shift.
    final repository = ref.watch(apiRepositoryProvider);
    return await repository.getAppointments();
  }

  // ─── MUTATION: ADD APPOINTMENT ─────────────────────────────────────────────
  Future<void> addAppointment(AppointmentModel appt) async {
    final previousState = state;

    // Instead of completely wiping out your UI state with a harsh hard-coded AsyncLoading,
    // this preserves the current list in the background while marking the state as loading.
    state = AsyncLoading<List<AppointmentModel>>().copyWithPrevious(previousState);

    try {
      final repository = ref.read(apiRepositoryProvider);

      // Optimize backend communications: Ensure the API returns the saved record
      // containing its primary ID keys from your Supabase / Spring Boot backend.
      final savedAppointment = await repository.bookAppointment(appt);

      // Update state locally inside the frontend application instantly,
      // bypassing the need to trigger an expensive secondary GET request.
      state = AsyncValue.data([
        ...?previousState.value,
        savedAppointment,
      ]);
    } catch (e, stack) {
      // Revert gracefully to previous list context while exposing the error target cleanly
      state = AsyncValue<List<AppointmentModel>>.error(e, stack).copyWithPrevious(previousState);
    }
  }

  // ─── MUTATION: REFRESH ROSTER ──────────────────────────────────────────────
  Future<void> refresh() async {
    final previousState = state;
    state = AsyncLoading<List<AppointmentModel>>().copyWithPrevious(previousState);

    try {
      final repository = ref.read(apiRepositoryProvider);
      final list = await repository.getAppointments();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue<List<AppointmentModel>>.error(e, stack).copyWithPrevious(previousState);
    }
  }
}

// ─── GLOBAL PROVIDER DEFINITION ──────────────────────────────────────────────
// Resolved compilation matching error by swapping target type to AutoDisposeAsyncNotifierProvider
final appointmentListProvider =
AutoDisposeAsyncNotifierProvider<AppointmentListNotifier, List<AppointmentModel>>(
  AppointmentListNotifier.new, // Standard modern idiomatic tear-off initialization syntax
);