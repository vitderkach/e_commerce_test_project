import 'package:flutter/material.dart';
import 'tenant_config.dart';
import '../theme/app_theme_extension.dart';

class UtilityPayTenant implements TenantConfig {
  @override
  String get tenantName => 'Utility Pay';

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        extensions: [
          const AppThemeExtension(
            primaryColor: Colors.blue,
            accentColor: Colors.lightBlueAccent,
            borderRadius: 4.0,
          ),
        ],
      );
}
