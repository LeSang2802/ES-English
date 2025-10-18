import 'package:dio/dio.dart';
import '../../configs/app_config.dart';
import '../../constants/local_storage.dart';

class BaseApiClient {
  static final BaseApiClient _instance = BaseApiClient._internal();
  factory BaseApiClient() => _instance;
  BaseApiClient._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  );

  final LocalStorage _storage = LocalStorage();

  Dio get dio => _dio;

  /// =================== REQUEST GET ===================
  Future<Response> get(String path) async {
    return await _dio.get(
      path,
      options: await _getHeaders(),
    );
  }

  /// =================== REQUEST POST ===================
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(
      path,
      data: data,
      options: await _getHeaders(),
    );
  }

  /// =================== REQUEST PUT ===================
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(
      path,
      data: data,
      options: await _getHeaders(),
    );
  }

  /// =================== REQUEST DELETE ===================
  Future<Response> delete(String path) async {
    return await _dio.delete(
      path,
      options: await _getHeaders(),
    );
  }

  /// =================== AUTH HEADERS (TOKEN) ===================
  Future<Options> _getHeaders() async {
    String? token = _storage.token;

    return Options(
      headers: {
        "Authorization": token != null ? "Bearer $token" : null,
      },
    );
  }
}
