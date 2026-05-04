import '../../di/injection.dart';
import '../base/page_theme_config.dart';

mixin PageConfigMixin<T> {
  T get pageConfig => getIt<PageThemeConfig>().get<T>();
}
