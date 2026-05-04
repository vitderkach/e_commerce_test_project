import 'package:flutter/services.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../domain/services/notification_service.dart';

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
