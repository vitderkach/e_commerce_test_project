import 'package:flutter/material.dart';
import '../../payment_widget_factory.dart';
import '../../../theme/app_theme_extension.dart';

class UtilityPaymentWidgetFactory implements PaymentWidgetFactory {
  @override
  Widget? buildPaymentBanner(BuildContext context, AppThemeExtension themeExt) {
    return _buildBillBreakdown(context, themeExt);
  }

  Widget _buildBillBreakdown(BuildContext context, AppThemeExtension themeExt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: themeExt.primaryColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BILL BREAKDOWN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: themeExt.primaryColor,
              letterSpacing: 1.2,
            ),
          ),
          const Divider(thickness: 1),
          _buildBillItem('Previous Balance', '\$142.50'),
          _buildBillItem('Current Usage (450kWh)', '\$67.50'),
          _buildBillItem('Maintenance Fee', '\$12.00'),
          _buildBillItem('Late Payment Fee', '\$5.00'),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL DUE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$227.00',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeExt.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
