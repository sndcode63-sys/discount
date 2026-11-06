import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.failure(String error, {int? statusCode, T? fallbackData}) {
    return ApiResponse(
      success: false,
      error: error,
      data: fallbackData,
      statusCode: statusCode ?? 500,
    );
  }
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;
  static const String tokenKey = 'app_auth_token';
  static const String userKey = 'app_user_data';
  static const String userRoleKey = 'app_user_role';

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: ApiConstants.connectTimeoutSeconds),
        receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Request & Auth Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // If 401 Unauthorized, token might be expired
          if (e.response?.statusCode == 401) {
            // handle session expiry if needed
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Auth Preferences Helpers
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user));
    if (user['role'] != null) {
      await prefs.setString(userRoleKey, user['role'].toString());
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(userKey);
    if (str != null) {
      try {
        return jsonDecode(str) as Map<String, dynamic>;
      } catch (_) {}
    }
    return null;
  }

  Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey) ?? 'customer';
  }

  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
    await prefs.remove(userRoleKey);
  }

  // Generic HTTP GET with error resilience
  Future<ApiResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }

  // Generic HTTP POST
  Future<ApiResponse<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }

  // Generic HTTP PUT
  Future<ApiResponse<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }

  ApiResponse<dynamic> _handleResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      // If the backend returns an explicit 'success' field, strictly respect it
      final bool success;
      if (data.containsKey('success')) {
        success = data['success'] == true;
      } else {
        success = response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300;
      }
      final message = data['message']?.toString();
      final error = data['error']?.toString();

      if (success) {
        return ApiResponse.success(
          data,
          message: message,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.failure(
          error ?? message ?? 'Request failed',
          statusCode: response.statusCode,
          fallbackData: data,
        );
      }
    }
    return ApiResponse.success(data, statusCode: response.statusCode);
  }

  ApiResponse<dynamic> _handleDioError(DioException e) {
    String errorMsg = 'Network error occurred. Please try again.';
    int? code = e.response?.statusCode;

    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      errorMsg = data['message'] ?? data['error'] ?? errorMsg;
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMsg = 'Connection timed out. Connecting to backup server...';
          break;
        case DioExceptionType.connectionError:
          errorMsg = 'No internet connection or server unreachable.';
          break;
        default:
          if (e.message != null && e.message!.isNotEmpty) {
            errorMsg = e.message!;
          }
      }
    }

    return ApiResponse.failure(
      errorMsg,
      statusCode: code,
      fallbackData: e.response?.data,
    );
  }
}
