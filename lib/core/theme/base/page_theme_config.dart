/// Base class for tenant-specific page configurations.
/// Groups all page-specific configurations accessible via a generic factory method.
abstract class PageThemeConfig {
  /// Returns the configuration for a specific page type [T].
  T get<T>();
}
