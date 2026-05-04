import 'package:flutter/material.dart';
import '../flavor/app_flavor.dart';
import 'retail/retail_shop_tenant.dart';
import 'utility/utility_pay_tenant.dart';

abstract class TenantConfig {
  String get tenantName;
  ThemeData get themeData;

  factory TenantConfig.fromFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.retailShop:
        return RetailShopTenant();
      case AppFlavor.utilityPay:
        return UtilityPayTenant();
    }
  }
}
