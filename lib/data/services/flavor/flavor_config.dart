import '../../models/flavor/app_flavor.dart';

class FlavorConfig {
  final AppFlavor flavor;

  FlavorConfig._({required this.flavor});

  static FlavorConfig? _instance;

  static void initialize(String? flavorName) {
    _instance = FlavorConfig._(
      flavor: AppFlavor.fromString(flavorName),
    );
  }

  static FlavorConfig get instance {
    assert(_instance != null, 'FlavorConfig must be initialized before use');
    return _instance!;
  }
}
