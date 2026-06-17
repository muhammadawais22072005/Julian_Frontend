import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;

  // 1. IMPROVED: Context-aware local endpoints for seamless cross-platform testing
  // Use 'http://10.0.2.2:8080/api' if testing on an Android Emulator
  static const String baseUrl = 'http:// 192.168.0.106:8080/api';

  // A function/callback to dynamically fetch the stored JWT token (e.g., from Flutter Secure Storage)
  final Future<String?> Function()? _tokenProvider;

  ApiService({Dio? dio, Future<String?> Function()? tokenProvider})
      : _tokenProvider = tokenProvider,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    // 2. ADDED: Interceptor to automatically append the Bearer Token to outgoing requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_tokenProvider != null) {
            final token = await _tokenProvider!();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get client => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String message = 'An unexpected error occurred';

    if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Receive timeout. The server took too long to respond.';
    } else if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      // Smartly extract custom error messages sent back by Spring Boot backend if available
      if (data is Map && data.containsKey('message')) {
        message = data['message'];
      } else {
        message = 'Server error ($statusCode): ${data ?? error.message}';
      }
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Failed to connect to the server. Is your backend running at $baseUrl?';
    }

    return Exception(message);
  }

  // ... (keep your existing get and post methods)

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

// ... (keep your existing _handleError method)
}

// ─── RIVERPOD PROVIDER ───────────────────────────────────────────────────────
// This gives your entire application access to the same ApiService instance
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    tokenProvider: () async {
      // Access the phone's secure hardware storage
      const storage = FlutterSecureStorage();
      return await storage.read(key: 'jwt_token');
    },
  );
});