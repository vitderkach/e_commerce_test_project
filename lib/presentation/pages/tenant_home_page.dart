import 'package:e_commerce_test_project/core/di/app_dependencies.dart';
import 'package:e_commerce_test_project/core/security/security_service.dart';
import 'package:e_commerce_test_project/core/tenant/tenant_config.dart';
import 'package:e_commerce_test_project/presentation/pages/payment_page.dart';
import 'package:e_commerce_test_project/presentation/pages/security_scanner_page.dart';
import 'package:flutter/material.dart';

class TenantHomePage extends StatefulWidget {
  const TenantHomePage({super.key});

  @override
  State<TenantHomePage> createState() => _TenantHomePageState();
}

class _TenantHomePageState extends State<TenantHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<SecurityService>().requestNotificationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tenant = TenantConfig.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tenant.tenantName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to ${tenant.tenantName}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
