import '../../../../domain/services/security_service.dart';

class NullSecurityService implements SecurityService {
  @override
  Future<bool> isRooted() async => false;

  @override
  Future<bool> isScreenRecording() async => false;

  @override
  Future<void> setSecureFlag(bool enable) async {}
}
