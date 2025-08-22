/// Enum to specify the type of dependency registration.
///
/// This enum defines all possible ways to register dependencies with GetIt,
/// providing flexibility for different use cases and performance requirements.
enum RegisterAs {
  /// Creates instance immediately and reuses it.
  ///
  /// Use this when you want the instance to be created right away and shared
  /// across all consumers. Good for configuration objects or services that
  /// are expensive to create but cheap to use.
  singleton,

  /// Creates new instance each time.
  ///
  /// Use this when you need a fresh instance every time. Good for objects
  /// that should not be shared or have state that changes between uses.
  factory,

  /// Creates instance on first use, then reuses it.
  ///
  /// Use this when you want the instance to be created only when first needed
  /// and then shared. Good for services that are expensive to create but
  /// you want to defer the creation cost.
  lazySingleton,

  /// Creates async instance each time.
  ///
  /// Use this when you need a new async instance every time. Good for
  /// objects that require async initialization and should not be shared.
  factoryAsync,

  /// Creates async instance on first use, then reuses it.
  ///
  /// Use this when you want the async instance to be created only when first
  /// needed and then shared. Good for services that require async initialization
  /// but you want to defer the creation cost.
  lazySingletonAsync,

  /// Creates async instance immediately and reuses it.
  ///
  /// Use this when you want the async instance to be created right away and
  /// shared across all consumers. Good for services that require async
  /// initialization and are expensive to create but cheap to use.
  singletonAsync,
}
