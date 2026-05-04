import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart';

import '../theme/app_theme_extension.dart';
import '../widgets/security_scanner_animation.dart';

class SecurityScannerPage extends StatelessWidget {
  const SecurityScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Animation'),
        backgroundColor: themeExt.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: StatsFl(child: SecurityScanner(color: themeExt.primaryColor)),
      ),
    );
  }
}
