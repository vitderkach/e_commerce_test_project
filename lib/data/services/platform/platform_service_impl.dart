import 'dart:io';
import '../../../domain/services/platform_service.dart';

class PlatformServiceImpl implements PlatformService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;
}
