export 'di.dart';
import '../../data/services/default/flavor/flavor_config.dart';
import '../../data/services/default/notification/null_notification_service.dart';
import '../../data/services/default/payment/null_payment_service.dart';
import '../../data/services/default/platform/platform_service_impl.dart';
import '../../data/services/default/security/null_security_service.dart';
import 'di.dart';
import '../../domain/services/platform_service.dart';
import '../logger/app_logger.dart';
import '../../domain/services/security_service.dart';
import '../../data/services/android/security/android_security_service.dart';
import '../../data/services/ios/security/ios_security_service.dart';
import '../../domain/services/payment_service.dart';
import '../../data/services/android/payment/android_payment_service.dart';
import '../../data/services/ios/payment/ios_payment_service.dart';
import '../../domain/services/notification_service.dart';
import '../../data/services/android/notification/android_notification_service.dart';
import '../../data/services/ios/notification/ios_notification_service.dart';
import '../../data/models/flavor/app_flavor.dart';
import '../../domain/theme/page_theme_config.dart';
import '../../presentation/theme/tenants/retail/retail_theme_config.dart';
import '../../presentation/theme/tenants/utility/utility_theme_config.dart';
import '../../presentation/factories/payment_widget_factory.dart';
import '../../presentation/factories/tenants/retail/retail_payment_widget_factory.dart';
import '../../presentation/factories/tenants/utility/utility_payment_widget_factory.dart';

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
        () => NullSecurityService(),
      );
      getIt.registerLazySingleton<PaymentService>(
        () => NullPaymentService(),
      );
      getIt.registerLazySingleton<NotificationService>(
        () => NullNotificationService(),
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
      () => RetailPaymentWidgetFactory(),
    );
    getIt.registerLazySingleton<PageThemeConfig>(() => RetailThemeConfig());
  }

  static void _registerUtilityDependencies() {
    getIt.registerLazySingleton<PaymentWidgetFactory>(
      () => UtilityPaymentWidgetFactory(),
    );
    getIt.registerLazySingleton<PageThemeConfig>(() => UtilityThemeConfig());
  }
}
