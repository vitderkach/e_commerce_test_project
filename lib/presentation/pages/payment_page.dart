import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';
import '../../core/di/injection.dart';
import '../../core/security/security_service.dart';
import '../../core/flavor/flavor_config.dart';
import '../../core/flavor/app_flavor.dart';
import '../factories/payment_widget_factory.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Widget? _cachedPaymentBanner;

  @override
  void initState() {
    super.initState();
    getIt<SecurityService>().setSecureFlag(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cachedPaymentBanner == null) {
      final themeExt = Theme.of(context).extension<AppThemeExtension>()!;
      _cachedPaymentBanner = getIt<PaymentWidgetFactory>().buildPaymentBanner(context, themeExt);
    }
  }

  @override
  void dispose() {
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
            if (_cachedPaymentBanner != null) _cachedPaymentBanner!,

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
}
