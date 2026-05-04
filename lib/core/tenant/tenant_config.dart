import 'package:flutter/material.dart';
import '../flavor/app_flavor.dart';
import 'retail/retail_shop_tenant.dart';
import 'utility/utility_pay_tenant.dart';

abstract class TenantConfigData {
  String get tenantName;
  ThemeData get themeData;
}

class TenantConfig extends InheritedWidget {
  final TenantConfigData data;

  const TenantConfig({
    super.key,
    required this.data,
    required super.child,
  });

  static TenantConfigData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TenantConfig>();
    assert(result != null, 'No TenantConfig found in context');
    return result!.data;
  }

  factory TenantConfig.fromFlavor({
    required AppFlavor flavor,
    required Widget child,
    Key? key,
  }) {
    final data = _getTenantData(flavor);
    return TenantConfig(key: key, data: data, child: child);
  }

  static TenantConfigData _getTenantData(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.retailShop:
        return RetailShopTenant();
      case AppFlavor.utilityPay:
        return UtilityPayTenant();
    }
  }

  @override
  bool updateShouldNotify(TenantConfig oldWidget) => data != oldWidget.data;
}
