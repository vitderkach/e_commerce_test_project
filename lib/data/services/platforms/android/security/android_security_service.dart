import 'package:flutter/services.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../domain/services/security_service.dart';

class AndroidSecurityService implements SecurityService {
  static const _channel = MethodChannel('com.example.e_commerce_test_project/security');

  @override
  Future<bool> isRooted() async {
    try {
      return await _channel.invokeMethod<bool>('isRooted') ?? false;
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidSecurityService: Error checking root status', e);
      return false;
    }
  }

  @override
  Future<bool> isScreenRecording() async {
    try {
      return await _channel.invokeMethod<bool>('isScreenRecording') ?? false;
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidSecurityService: Error checking screen recording status', e);
      return false;
    }
  }

  @override
  Future<void> setSecureFlag(bool enable) async {
    try {
      await _channel.invokeMethod('setSecureFlag', {'enable': enable});
    } on PlatformException catch (e) {
      getIt<AppLogger>().error('AndroidSecurityService: Error setting secure flag', e);
    }
  }
}
