import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

abstract class PaymentWidgetFactory {
  Widget? buildPaymentBanner(BuildContext context, AppThemeExtension themeExt);
}
