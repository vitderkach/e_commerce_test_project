import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart';
import '../../core/theme/app_theme_extension.dart';
import '../../core/di/injection.dart';
import '../../core/security/security_service.dart';
import '../widgets/security_scanner_animation.dart';

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

    if (!mounted) return;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Payment'),
        backgroundColor: themeExt.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Complete your purchase',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40),
            _buildPaymentMethod(
              context,
              icon: Icons.credit_card,
              label: 'Credit Card',
              themeExt: themeExt,
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              context,
              icon: Icons.account_balance,
              label: 'Bank Transfer',
              themeExt: themeExt,
            ),
            const SizedBox(height: 32),
            StatsFl(child:
            SecurityScanner(
              //color: themeExt.primaryColor,
              //size: 150,
            ),),
            const SizedBox(height: 32),
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

  Widget _buildPaymentMethod(
    BuildContext context, {
    required IconData icon,
    required String label,
    required AppThemeExtension themeExt,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(themeExt.borderRadius),
      ),
      child: Row(
        children: [
          Icon(icon, color: themeExt.primaryColor, size: 32),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          const Icon(Icons.radio_button_off, color: Colors.grey),
        ],
      ),
    );
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
