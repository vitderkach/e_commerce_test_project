import 'package:flutter/material.dart';
import '../../../base/pages/payment_page_theme_config.dart';

class RetailPaymentPageThemeConfig implements PaymentPageThemeConfig {
  @override
  EdgeInsets get padding => const EdgeInsets.all(24.0);

  @override
  double get topSpacing => 40.0;

  @override
  double get bannerSpacing => 32.0;
}
