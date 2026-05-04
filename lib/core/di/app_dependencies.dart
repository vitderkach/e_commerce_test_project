export 'injection.dart';
import 'injection.dart';
import '../../domain/services/platform_service.dart';
import '../../data/services/platform/platform_service_impl.dart';
import '../logger/app_logger.dart';
import '../../domain/services/security_service.dart';
import '../../data/services/security/android_security_service.dart';
import '../../data/services/security/ios_security_service.dart';
import '../../data/services/security/default_security_service.dart';
import '../../domain/services/payment_service.dart';
import '../../data/services/payment/android_payment_service.dart';
import '../../data/services/payment/ios_payment_service.dart';
import '../../data/services/payment/default_payment_service.dart';
import '../../domain/services/notification_service.dart';
import '../../data/services/notification/android_notification_service.dart';
import '../../data/services/notification/ios_notification_service.dart';
import '../../data/services/notification/default_notification_service.dart';
import '../../data/services/flavor/flavor_config.dart';
import '../../data/models/flavor/app_flavor.dart';
import '../../domain/theme/page_theme_config.dart';
import '../../presentation/theme/retail/retail_theme_config.dart';
import '../../presentation/theme/utility/utility_theme_config.dart';
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
