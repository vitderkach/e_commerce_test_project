import 'dart:io';

abstract class PlatformService {
  bool get isAndroid;
  bool get isIOS;
}

class PlatformServiceImpl implements PlatformService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;
}
