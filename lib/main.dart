import 'package:e_commerce_test_project/presentation/pages/security_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/flavor/flavor_config.dart';
import 'core/tenant/tenant_config.dart';
import 'core/theme/app_theme_extension.dart';
import 'core/di/injection.dart';
import 'presentation/pages/payment_page.dart';
import 'core/security/security_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Injection.init();

  // Request notification permission on app start (Android 13+)
  getIt<SecurityService>().requestNotificationPermission();

  // In Flutter 3.16+, appFlavor from services.dart provides the flavor
  // passed via the --flavor flag during build/run.
  FlavorConfig.initialize(appFlavor);

  runApp(const MultiTenantApp());
}

class MultiTenantApp extends StatelessWidget {
  const MultiTenantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final flavor = FlavorConfig.instance.flavor;
    final tenant = TenantConfig.fromFlavor(flavor);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: tenant.tenantName,
      theme: tenant.themeData,
      home: TenantHomePage(title: tenant.tenantName),
    );
  }
}

class TenantHomePage extends StatelessWidget {
  final String title;
  const TenantHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to $title',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const TenantBrandedWidget(),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('Go to Payment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SecurityScannerPage()),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('Go to Animation'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantBrandedWidget extends StatelessWidget {
  const TenantBrandedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing tenant-specific theme tokens via ThemeExtension
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeExt.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(themeExt.borderRadius),
        border: Border.all(color: themeExt.primaryColor, width: 2),
      ),
      child: Text(
        'This widget is styled using ThemeExtension\nBorder Radius: ${themeExt.borderRadius}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: themeExt.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
