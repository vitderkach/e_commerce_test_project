export 'injection.dart';
import 'injection.dart';
import '../platform/platform_service.dart';
import '../platform/default/platform_service_impl.dart';
import '../logger/app_logger.dart';
import '../security/security_service.dart';
import '../security/android/android_security_service.dart';
import '../security/ios/ios_security_service.dart';
import '../security/default/default_security_service.dart';
import '../payment/payment_service.dart';
import '../payment/android/android_payment_service.dart';
import '../payment/ios/ios_payment_service.dart';
import '../payment/default/default_payment_service.dart';
import '../notification/notification_service.dart';
import '../notification/android/android_notification_service.dart';
import '../notification/ios/ios_notification_service.dart';
import '../notification/default/default_notification_service.dart';
import '../flavor/flavor_config.dart';
import '../flavor/app_flavor.dart';
import '../theme/base/page_theme_config.dart';
import '../theme/retail/retail_theme_config.dart';
import '../theme/utility/utility_theme_config.dart';
import '../../presentation/factories/payment_widget_factory.dart';
import '../../presentation/factories/retail/retail_payment_widget_factory.dart';
import '../../presentation/factories/utility/utility_payment_widget_factory.dart';

class AppDependencies {
  static Future<void> init() async {
    getIt.registerLazySingleton<AppLogger>(() => AppLoggerImpl());
    getIt.registerLazySingleton<PlatformService>(() => PlatformServiceImpl());

    PlatformModule.register(getIt<PlatformService>());

    TenantModule.register();
  }
}

class PlatformModule {
  static void register(PlatformService platformService) {
    if (platformService.isAndroid) {
      getIt.registerLazySingleton<SecurityService>(
        () => AndroidSecurityService(),
      );
      getIt.registerLazySingleton<PaymentService>(
        () => AndroidPaymentService(),
      );
      getIt.registerLazySingleton<NotificationService>(
        () => AndroidNotificationService(),
      );
    } else if (platformService.isIOS) {
      getIt.registerLazySingleton<SecurityService>(() => IOSSecurityService());
      getIt.registerLazySingleton<PaymentService>(() => IOSPaymentService());
      getIt.registerLazySingleton<NotificationService>(
        () => IOSNotificationService(),
      );
    } else {
      getIt.registerLazySingleton<SecurityService>(
        () => DefaultSecurityService(),
      );
      getIt.registerLazySingleton<PaymentService>(
        () => DefaultPaymentService(),
      );
      getIt.registerLazySingleton<NotificationService>(
        () => DefaultNotificationService(),
      );
    }
  }
}

class TenantModule {
  static void register() {
    final flavor = FlavorConfig.instance.flavor;
    if (flavor == AppFlavor.retailShop) {
      _registerRetailDependencies();
    } else {
      _registerUtilityDependencies();
    }
  }

  static void _registerRetailDependencies() {
    getIt.registerLazySingleton<PaymentWidgetFactory>(
      () => UtilityPaymentWidgetFactory(),
    );
    getIt.registerLazySingleton<PageThemeConfig>(() => UtilityThemeConfig());
  }

  static void _registerUtilityDependencies() {
    getIt.registerLazySingleton<PaymentWidgetFactory>(
      () => UtilityPaymentWidgetFactory(),
    );
    getIt.registerLazySingleton<PageThemeConfig>(() => UtilityThemeConfig());
  }
}
