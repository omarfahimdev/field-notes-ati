import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import '../storage/local_storage.dart';

class ApiClient {
  ApiClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: _storage.baseUrl ?? AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final token = _storage.token;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    }));
  }

  final LocalStorage _storage;
  late final Dio _dio;

  void updateBaseUrl(String? url) {
    final base = (url == null || url.trim().isEmpty) ? AppConstants.apiBaseUrl : url.trim();
    _dio.options.baseUrl = base;
  }

  Future<dynamic> get(String path) => _request(() => _dio.get(path));
  Future<dynamic> post(String path, {Object? data}) => _request(() => _dio.post(path, data: data));
  Future<dynamic> put(String path, {Object? data}) => _request(() => _dio.put(path, data: data));
  Future<void> delete(String path) => _request(() => _dio.delete(path));

  Future<dynamic> _request(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return res.data;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      String message = 'Something went wrong';
      if (data is Map) {
        message = (data['message'] ?? data['error'] ?? message).toString();
      } else if (data is String && data.isNotEmpty) {
        message = data;
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        message = 'No connection to server';
      }
      debugPrint('API error $status: $message');
      throw AppException(message, statusCode: status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(e.toString());
    }
  }
}
