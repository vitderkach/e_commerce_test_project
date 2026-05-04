import 'package:flutter/material.dart';
import '../theme/app_theme_extension.dart';

abstract class PaymentWidgetFactory {
  Widget? buildPaymentBanner(BuildContext context, AppThemeExtension themeExt);
}
