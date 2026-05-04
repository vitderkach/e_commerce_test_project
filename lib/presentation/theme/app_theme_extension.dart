import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color primaryColor;
  final Color accentColor;
  final double borderRadius;

  const AppThemeExtension({
    required this.primaryColor,
    required this.accentColor,
    required this.borderRadius,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primaryColor,
    Color? accentColor,
    double? borderRadius,
  }) {
    return AppThemeExtension(
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      borderRadius: BorderRadius.lerp(
        BorderRadius.circular(borderRadius),
        BorderRadius.circular(other.borderRadius),
        t,
      )!.bottomLeft.x, // Simplified lerp for double
    );
  }
}
