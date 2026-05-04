import 'package:flutter/services.dart';
import '../../di/injection.dart';
import '../../logger/app_logger.dart';
import '../payment_service.dart';

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
