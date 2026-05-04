import 'dart:async';
import 'package:flutter/services.dart';
import '../../../../core/di/di.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../domain/services/notification_service.dart';

class AndroidNotificationService implements NotificationService {
  static const _channel = MethodChannel('com.example.e_commerce_test_project/notifications');

  final _onPaymentFinishedController = StreamController<void>.broadcast();

  AndroidNotificationService() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onPaymentFinished':
        _onPaymentFinishedController.add(null);
        break;
      default:
        getIt<AppLogger>().info('AndroidNotificationService: Unhandled method ${call.method}');
    }
  }

  @override
  Future<void> requestNotificationPermission() async {
    try {
      await _channel.invokeMethod('requestNotificationPermission');
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidNotificationService: Error requesting notification permission', e);
    }
  }
}
