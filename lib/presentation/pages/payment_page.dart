import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';
import '../../core/di/injection.dart';
import '../../core/security/security_service.dart';
import '../../core/flavor/flavor_config.dart';
import '../../core/flavor/app_flavor.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    // Enable secure flag when entering the payment page
    getIt<SecurityService>().setSecureFlag(true);
  }

  @override
  void dispose() {
    // Disable secure flag when leaving the payment page
    getIt<SecurityService>().setSecureFlag(false);
    super.dispose();
  }

  Future<void> _checkSecurityAndPay(BuildContext context, AppThemeExtension themeExt) async {
    final securityService = getIt<SecurityService>();
    
    final isRooted = await securityService.isRooted();
    final isRecording = await securityService.isScreenRecording();

    if (!context.mounted) return;

    if (isRooted || isRecording) {
      String reason = isRooted ? "Device is rooted" : "Screen recording detected";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Security Alert'),
          content: Text('Payment blocked: $reason. For your security, payments are disabled on compromised devices or during screen sharing.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Understand'),
            ),
          ],
        ),
      );
      return;
    }

    _processPayment(context, themeExt);
  }

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;
    final isUtility = FlavorConfig.instance.flavor == AppFlavor.utilityPay;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Payment'),
        backgroundColor: themeExt.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isUtility ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Complete your purchase',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: isUtility ? 24 : 40),
              if (FlavorConfig.instance.flavor == AppFlavor.retailShop)
                _buildPromoBanner(context, themeExt),
              if (isUtility)
                _buildBillBreakdown(context, themeExt),

            SizedBox(height: isUtility ? 16 : 32),
            OutlinedButton.icon(
              onPressed: () {
                getIt<SecurityService>().startPayment();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing payment in background... Check notifications.')),
                );
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Buy Mock Item (Foreground Service)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: themeExt.primaryColor),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _checkSecurityAndPay(context, themeExt),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeExt.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(themeExt.borderRadius),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),);
  }

  void _processPayment(BuildContext context, AppThemeExtension themeExt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your transaction has been processed securely.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to home
            },
            child: Text('OK', style: TextStyle(color: themeExt.primaryColor)),
          ),
        ],
      ),
    );
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

  Widget _buildPromoBanner(BuildContext context, AppThemeExtension themeExt) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [themeExt.primaryColor, themeExt.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(themeExt.borderRadius),
          boxShadow: [
            BoxShadow(
              color: themeExt.primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.stars, color: Colors.white, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RETAIL SPECIAL!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Get 10% cashback on this purchase',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
