import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/app_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/dev_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/prod_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/http/dio/dio_provider.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Initialize and register all dependencies
Future<void> setupDependencyInjection({
  bool isProduction = false,
}) async {
  // Register AppEnvironment as singleton
  final environment = isProduction
      ? const ProdEnvironment()
      : const DevEnvironment();
  getIt.registerSingleton<AppEnvironment>(environment);

  // Initialize Dio with environment configuration
  final dio = DioProvider.initializeDio(environment);
  getIt.registerSingleton<Dio>(dio);

  // TODO: Register repositories here
  // getIt.registerSingleton<TicketRepository>(TicketRepository(getIt<Dio>()));
}
