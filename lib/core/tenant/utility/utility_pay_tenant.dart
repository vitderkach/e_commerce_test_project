import 'package:flutter/material.dart';
import '../tenant_config.dart';
import '../../theme/app_theme_extension.dart';

class UtilityPayTenant implements TenantConfigData {
  @override
  String get tenantName => 'Utility Pay';

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Navy 900
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF455A64), // Slate
        ),
        extensions: [
          const AppThemeExtension(
            primaryColor: Color(0xFF1A237E),
            accentColor: Color(0xFF455A64),
            borderRadius: 0.0, // Sharp edges
          ),
        ],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
}
