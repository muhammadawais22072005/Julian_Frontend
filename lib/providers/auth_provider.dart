import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:julian_medical_center/data/models/user_model.dart';
import 'package:julian_medical_center/data/services/api_service.dart';
import 'package:julian_medical_center/data/repositories/api_repository.dart';
import 'package:julian_medical_center/data/repositories/api_repository_impl.dart';

// ─── SERVICE & REPOSITORY PROVIDERS ──────────────────────────────────────────

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  // Swapped to ref.watch to safely rebind state graphs if service elements dynamically alter
  final apiService = ref.watch(apiServiceProvider);
  return ApiRepositoryImpl(apiService, preferMocks: true);
});

// ─── AUTHENTICATION STATE DOMAIN SCHEMA ──────────────────────────────────────

class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.errorMessage,
  });


  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage, // Resets cleanly if a explicit null is passed downstream
    );
  }
}

// ─── AUTHENTICATION ASYNC NOTIFIER ENGINE ────────────────────────────────────

class AuthNotifier extends AutoDisposeAsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Initial state represents a clean, unauthenticated session profile node
    return const AuthState();
  }

  // ─── ACTION: LOGIN ─────────────────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    // Correct async state updates utilize the guard() framework utility method.
    // This catches errors automatically, wrapping them cleanly into AsyncValue containers.
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(apiRepositoryProvider);
      final user = await repository.signIn(email, password);
      return AuthState(user: user, isAuthenticated: true);
    });
  }

  // ─── ACTION: REGISTER ──────────────────────────────────────────────────────
  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(apiRepositoryProvider);
      final user = await repository.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      return AuthState(user: user, isAuthenticated: true);
    });
  }

  // ─── ACTION: LOGOUT ────────────────────────────────────────────────────────
  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(apiRepositoryProvider);
      await repository.signOut(); // Ensure backend tokens/sessions clear safely
      return const AuthState();
    });
  }
}

// ─── GLOBAL PROVIDER HOOK MAPPING ────────────────────────────────────────────

// Fully typed provider wrapper ensures perfect compiler integration across views
final authProvider =
AutoDisposeAsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);