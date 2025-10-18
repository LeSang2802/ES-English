// import 'package:dio/dio.dart';
// import '../../configs/app_config.dart';
// import 'method_api.dart';
//
// class ApiService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: AppConfig.baseUrl,
//       connectTimeout: Duration(seconds: 10),
//       receiveTimeout: Duration(seconds: 10),
//     ),
//   );
//
//   Future<Response> request(String path, MethodApi method, {Map<String, dynamic>? data}) async {
//     try {
//       switch (method) {
//         case MethodApi.get:
//           return await _dio.get(path);
//         case MethodApi.post:
//           return await _dio.post(path, data: data);
//         case MethodApi.put:
//           return await _dio.put(path, data: data);
//         case MethodApi.delete:
//           return await _dio.delete(path);
//         case MethodApi.patch:
//           return await _dio.patch(path, data: data);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
