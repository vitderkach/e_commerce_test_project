import '../../../domain/services/security_service.dart';

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
}
