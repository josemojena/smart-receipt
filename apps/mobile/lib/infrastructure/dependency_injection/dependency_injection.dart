import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/app_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/dev_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/environment/prod_environment.dart';
import 'package:smart_receipt_mobile/infrastructure/http/dio/dio_provider.dart';
import 'package:smart_receipt_mobile/infrastructure/services/image_upload_service.dart';

/// Service locator instance
final GetIt getIt = GetIt.instance;

/// Initialize and register all dependencies
Future<void> setupDependencyInjection({
  bool isProduction = false,
}) async {
  final environment = isProduction
      ? const ProdEnvironment()
      : const DevEnvironment();
  getIt.registerSingleton<AppEnvironment>(environment);

  final dio = DioProvider.initializeDio(environment);
  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<ImageUploadService>(
    ImageUploadService(dio),
  );

  // TODO: Register repositories here
  // getIt.registerSingleton<TicketRepository>(TicketRepository(getIt<Dio>()));
}
