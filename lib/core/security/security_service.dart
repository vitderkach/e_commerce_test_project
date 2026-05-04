abstract class SecurityService {
  Future<bool> isRooted();
  Future<bool> isScreenRecording();
  Future<void> setSecureFlag(bool enable);
}
