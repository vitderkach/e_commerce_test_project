import 'package:flutter/services.dart';
import '../security_service.dart';

class AndroidSecurityService implements SecurityService {
  static const _channel = MethodChannel('com.example.e_commerce_test_project/security');

  @override
  Future<bool> isRooted() async {
    try {
      return await _channel.invokeMethod<bool>('isRooted') ?? false;
    } on PlatformException catch (e) {
      print('AndroidSecurityService: Error checking root status: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> isScreenRecording() async {
    try {
      return await _channel.invokeMethod<bool>('isScreenRecording') ?? false;
    } on PlatformException catch (e) {
      print('AndroidSecurityService: Error checking screen recording status: ${e.message}');
      return false;
    }
  }

  @override
  Future<void> setSecureFlag(bool enable) async {
    try {
      await _channel.invokeMethod('setSecureFlag', {'enable': enable});
    } on PlatformException catch (e) {
      print('AndroidSecurityService: Error setting secure flag: ${e.message}');
    }
  }

  @override
  Future<void> startPayment() async {
    try {
      await _channel.invokeMethod('startPayment');
    } on PlatformException catch (e) {
      print('AndroidSecurityService: Error starting payment: ${e.message}');
    }
  }

  @override
  Future<void> requestNotificationPermission() async {
    try {
      await _channel.invokeMethod('requestNotificationPermission');
    } on PlatformException catch (e) {
      print('AndroidSecurityService: Error requesting notification permission: ${e.message}');
    }
  }
}
