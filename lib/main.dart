import 'package:e_commerce_test_project/presentation/pages/tenant_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/flavor/flavor_config.dart';
import 'core/tenant/tenant_config.dart';
import 'core/di/app_dependencies.dart';

void main() async {
  FlavorConfig.initialize(appFlavor);
  await AppDependencies.init();

  runApp(const MultiTenantApp());
}

class MultiTenantApp extends StatelessWidget {
  const MultiTenantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final flavor = FlavorConfig.instance.flavor;

    return TenantConfig.fromFlavor(
      flavor: flavor,
      child: Builder(
        builder: (context) {
          final tenant = TenantConfig.of(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: tenant.tenantName,
            theme: tenant.themeData,
            home: const TenantHomePage(),
          );
        },
      ),
    );
  }
}


