enum AppFlavor {
  retailShop('retail_shop'),
  utilityPay('utility_pay');

  final String name;
  const AppFlavor(this.name);

  static AppFlavor fromString(String? flavor) {
    return AppFlavor.values.firstWhere(
      (e) => e.name == flavor,
      orElse: () => AppFlavor.retailShop,
    );
  }
}
