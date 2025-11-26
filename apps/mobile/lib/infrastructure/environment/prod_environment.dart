import 'package:smart_receipt_mobile/infrastructure/environment/app_environment.dart';

class ProdEnvironment extends AppEnvironment {
  const ProdEnvironment()
    : super(
        name: 'prod',
        apiUrl: 'https://api.smartreceipt.com',
        authToken: '',
      );
}
