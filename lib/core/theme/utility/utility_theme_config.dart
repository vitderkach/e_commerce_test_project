import '../base/page_theme_config.dart';
import '../base/pages/payment_page_theme_config.dart';
import 'pages/utility_payment_page_theme_config.dart';

class UtilityThemeConfig implements PageThemeConfig {
  @override
  T get<T>() {
    if (T == PaymentPageThemeConfig) {
      return UtilityPaymentPageThemeConfig() as T;
    }
    throw UnimplementedError('No Utility config found for type $T');
  }
}
