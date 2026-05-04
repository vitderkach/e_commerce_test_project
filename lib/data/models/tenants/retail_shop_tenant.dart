import 'package:flutter/material.dart';
import '../../../domain/models/tenant_config_data.dart';
import '../../../presentation/theme/app_theme_extension.dart';

class RetailShopTenant implements TenantConfigData {
  @override
  String get tenantName => 'Retail Shop';

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
          secondary: Colors.amber,
        ),
        extensions: [
          const AppThemeExtension(
            primaryColor: Colors.orange,
            accentColor: Colors.amber,
            borderRadius: 24.0,
          ),
        ],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      );
}
