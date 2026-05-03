import 'package:flutter/material.dart';
import 'tenant_config.dart';
import '../theme/app_theme_extension.dart';

class RetailShopTenant implements TenantConfig {
  @override
  String get tenantName => 'Retail Shop';

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
        ),
        extensions: [
          const AppThemeExtension(
            primaryColor: Colors.orange,
            accentColor: Colors.deepOrangeAccent,
            borderRadius: 12.0,
          ),
        ],
      );
}
