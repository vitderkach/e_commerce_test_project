import 'package:get_it/get_it.dart';
import '../platform/platform_service.dart';
import '../security/security_service.dart';

final getIt = GetIt.instance;

class Injection {
  static Future<void> init() async {
    // Platform Service
    getIt.registerLazySingleton<PlatformService>(() => PlatformServiceImpl());

    // Register platform-dependent services
    PlatformModule.register(getIt<PlatformService>());
  }
}

class PlatformModule {
  static void register(PlatformService platformService) {
    if (platformService.isAndroid) {
      getIt.registerLazySingleton<SecurityService>(() => AndroidSecurityService());
    } else if (platformService.isIOS) {
      getIt.registerLazySingleton<SecurityService>(() => IOSSecurityService());
    } else {
      getIt.registerLazySingleton<SecurityService>(() => DefaultSecurityService());
    }
  }
}
