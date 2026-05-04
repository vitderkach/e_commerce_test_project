import '../../../core/di/di.dart';
import '../../../domain/theme/page_theme_config.dart';

mixin PageConfigMixin<T> {
  T get pageConfig => getIt<PageThemeConfig>().get<T>();
}
