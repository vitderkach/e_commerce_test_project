import '../../../../domain/theme/page_theme_config.dart';
import '../../base/pages/payment_page_theme_config.dart';
import 'pages/retail_payment_page_theme_config.dart';

class RetailThemeConfig implements PageThemeConfig {
  @override
  T get<T>() {
    if (T == PaymentPageThemeConfig) {
      return RetailPaymentPageThemeConfig() as T;
    }
    throw UnimplementedError('No Retail config found for type $T');
  }
}
