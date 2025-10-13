import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late Dio _dio;
  
  // Configure aqui a URL do seu Spring Boot
  static const String baseUrl = 'http://localhost:8080/';

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (!await hasConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Sem conexão com a internet',
      );
    }
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    if (!await hasConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Sem conexão com a internet',
      );
    }
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    if (!await hasConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Sem conexão com a internet',
      );
    }
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    if (!await hasConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Sem conexão com a internet',
      );
    }
    return await _dio.delete(path);
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}