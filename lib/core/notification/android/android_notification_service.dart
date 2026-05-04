import 'package:flutter/services.dart';
import '../../di/injection.dart';
import '../../logger/app_logger.dart';
import '../notification_service.dart';

class AndroidNotificationService implements NotificationService {
  static const _channel = MethodChannel('com.example.e_commerce_test_project/security');

  @override
  Future<void> requestNotificationPermission() async {
    try {
      await _channel.invokeMethod('requestNotificationPermission');
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidNotificationService: Error requesting notification permission', e);
    }
  }
}
