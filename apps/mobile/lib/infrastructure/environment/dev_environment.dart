import 'package:smart_receipt_mobile/infrastructure/environment/app_environment.dart';

class DevEnvironment extends AppEnvironment {
  const DevEnvironment()
    : super(
        name: 'dev',
        apiUrl: 'https://api-dev.smartreceipt.com',
        authToken: '',
      );
}
