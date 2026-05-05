import 'dart:async';
import 'package:flutter/services.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../domain/services/permission_service.dart';

class AndroidPermissionService implements PermissionService {
  static const _channel = MethodChannel('com.example.e_commerce_test_project/permissions');

  @override
  Future<void> requestNotificationPermission() async {
    try {
      await _channel.invokeMethod('requestNotificationPermission');
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidPermissionService: Error requesting permission', e);
    }
  }
}
