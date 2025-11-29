import 'dart:io';

import 'package:smart_receipt_mobile/infrastructure/environment/app_environment.dart';

class DevEnvironment extends AppEnvironment {
  DevEnvironment()
    : super(
        name: 'dev',
        apiUrl: Platform.isAndroid
            ? 'http://10.0.2.2:3001'
            : 'http://localhost:3001',
        authToken: '',
      );
}
