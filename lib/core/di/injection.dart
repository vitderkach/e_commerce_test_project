import 'package:get_it/get_it.dart';
import '../platform/platform_service.dart';
import '../platform/default/platform_service_impl.dart';
import '../security/security_service.dart';
import '../security/android/android_security_service.dart';
import '../security/ios/ios_security_service.dart';
import '../security/default/default_security_service.dart';
import '../flavor/flavor_config.dart';
import '../flavor/app_flavor.dart';
import '../../presentation/factories/payment_widget_factory.dart';
import '../../presentation/factories/retail/retail_payment_widget_factory.dart';
import '../../presentation/factories/utility/utility_payment_widget_factory.dart';

final getIt = GetIt.instance;

class Injection {
  static Future<void> init() async {
    // Platform Service
    getIt.registerLazySingleton<PlatformService>(() => PlatformServiceImpl());

    // Register platform-dependent services
    PlatformModule.register(getIt<PlatformService>());

    // Payment Widget Factory
    final flavor = FlavorConfig.instance.flavor;
    if (flavor == AppFlavor.retailShop) {
      getIt.registerLazySingleton<PaymentWidgetFactory>(() => RetailPaymentWidgetFactory());
    } else {
      getIt.registerLazySingleton<PaymentWidgetFactory>(() => UtilityPaymentWidgetFactory());
    }
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
