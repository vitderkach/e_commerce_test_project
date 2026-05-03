import 'package:flutter/services.dart';

abstract class SecurityService {
  Future<bool> isRooted();
  Future<bool> isScreenRecording();
  Future<void> setSecureFlag(bool enable);
  Future<void> startPayment();
  Future<void> requestNotificationPermission();
}

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

class IOSSecurityService implements SecurityService {
  @override
  Future<bool> isRooted() async {
    // TODO: Implement iOS side (e.g. check for Cydia, hidden files, or use a package)
    return false;
  }

  @override
  Future<bool> isScreenRecording() async {
    // TODO: Implement iOS side using UIScreen.main.isCaptured
    return false;
  }

  @override
  Future<void> setSecureFlag(bool enable) async {
    // TODO: Implement iOS side (e.g. prevent screen recording/screenshots if possible)
  }

  @override
  Future<void> startPayment() async {
    // TODO: Implement iOS background task
  }

  @override
  Future<void> requestNotificationPermission() async {
    // TODO: Implement iOS notification permission request
  }
}

class DefaultSecurityService implements SecurityService {
  @override
  Future<bool> isRooted() async => false;

  @override
  Future<bool> isScreenRecording() async => false;

  @override
  Future<void> setSecureFlag(bool enable) async {}

  @override
  Future<void> startPayment() async {}

  @override
  Future<void> requestNotificationPermission() async {}
}
