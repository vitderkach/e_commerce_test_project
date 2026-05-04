import 'package:flutter/material.dart';
import '../../base/pages/payment_page_theme_config.dart';

class UtilityPaymentPageThemeConfig implements PaymentPageThemeConfig {
  @override
  EdgeInsets get padding => const EdgeInsets.all(16.0);

  @override
  double get topSpacing => 24.0;

  @override
  double get bannerSpacing => 16.0;
}
