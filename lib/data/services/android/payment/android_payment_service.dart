import 'package:flutter/services.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../domain/services/payment_service.dart';

class AndroidPaymentService implements PaymentService {
  static const _channel = MethodChannel('com.example.e_commerce_test_project/security');

  @override
  Future<void> startPayment() async {
    try {
      await _channel.invokeMethod('startPayment');
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidPaymentService: Error starting payment', e);
    }
  }
}
