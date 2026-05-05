import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme_extension.dart';
import '../theme/base/pages/payment_page_theme_config.dart';
import '../theme/mixins/tenant_config_mixins.dart';
import '../../core/di/app_dependencies.dart';
import '../../domain/services/security_service.dart';
import '../factories/payment_widget_factory.dart';
import '../cubits/payment_cubit.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with PageConfigMixin<PaymentPageThemeConfig> {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PaymentCubit>(),
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSecurityBlocked) {
            _showSecurityAlert(context, state.reason);
          } else if (state is PaymentSuccess) {
            _showPaymentSuccessDialog(context);
          }
        },
        child: Builder(
          builder: (context) {
            final themeExt = Theme.of(context).extension<AppThemeExtension>()!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Secure Payment'),
                backgroundColor: themeExt.primaryColor,
                foregroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: pageConfig.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Complete your purchase',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: pageConfig.topSpacing),
                      if (_cachedPaymentBanner != null) _cachedPaymentBanner!,
                      SizedBox(height: pageConfig.bannerSpacing),
                      BlocBuilder<PaymentCubit, PaymentState>(
                        builder: (context, state) {
                          final isLoading = state is PaymentSecurityChecking || state is PaymentProcessing;
                          return ElevatedButton(
                            onPressed: isLoading ? null : () => context.read<PaymentCubit>().checkSecurityAndPay(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeExt.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(themeExt.borderRadius),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Pay Now',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSecurityAlert(BuildContext context, String reason) {
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
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Is In Progress'),
        content: const Text('Your transaction is being processed securely.\nCheck the status in the notification panel.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK', style: TextStyle(color: themeExt.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    getIt<SecurityService>().setSecureFlag(false);
    super.dispose();
  }
}
