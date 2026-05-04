import 'package:flutter/material.dart';
import '../../data/models/flavor/app_flavor.dart';
import '../../data/models/tenants/retail_shop_tenant.dart';
import '../../data/models/tenants/utility_pay_tenant.dart';
import '../../domain/models/tenant_config_data.dart';

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
