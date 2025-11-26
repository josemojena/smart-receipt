import 'package:dio/dio.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/app_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/http/dio/dio_config.dart';
import 'package:smart_receipt_mobile/infrastructure/http/dio/dio_interceptors.dart';

class DioProvider {
  static Dio initializeDio(AppEnvironment environment) {
    final dio = Dio(
      BaseOptions(
        baseUrl: environment.apiUrl,
        connectTimeout: DioConfig.connectTimeout,
        receiveTimeout: DioConfig.receiveTimeout,
        headers: DioConfig.defaultHeaders,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    dio.interceptors.addAll(DioInterceptors.getInterceptors());

    return dio;
  }
}
