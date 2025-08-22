import 'package:get_it/get_it.dart';
import 'register_as.dart';

/// Extension on GetIt to provide optimized lazy loading functionality.
///
/// This extension provides convenient methods for getting or registering dependencies
/// with GetIt, ensuring optimal performance and clean dependency management.
///
/// ## Usage
///
/// ```dart
/// import 'package:get_it/get_it.dart';
/// import 'package:get_it_lazyload/get_it_lazyload.dart';
///
/// final getIt = GetIt.instance;
///
/// // Register a service
/// getIt.getOrRegister<MyService>(() => MyService(), RegisterAs.singleton);
///
/// // Get the service (will be created if not registered)
/// final service = getIt.get<MyService>();
/// ```
extension GetItExtension on GetIt {
  /// Gets or registers a dependency with optimized lazy loading.
  ///
  /// This method checks if a dependency is already registered and either returns
  /// the existing instance or registers a new one based on the specified type.
  ///
  /// [instanceCreator] - Function that creates the instance
  /// [registerAs] - Type of registration (factory, singleton, lazySingleton, etc.)
  ///
  /// Returns the dependency instance.
  T getOrRegister<T extends Object>(
    T Function() instanceCreator,
    RegisterAs registerAs,
  ) {
    // Optimized: Check registration once and handle accordingly
    if (!isRegistered<T>()) {
      switch (registerAs) {
        case RegisterAs.singleton:
          // Optimized: Create instance once and register
          registerSingleton<T>(instanceCreator());
          break;
        case RegisterAs.factory:
          // Optimized: Direct function registration without extra wrapping
          registerFactory<T>(instanceCreator);
          break;
        case RegisterAs.lazySingleton:
          // Optimized: Direct function registration without extra wrapping
          registerLazySingleton<T>(instanceCreator);
          break;
        default:
          throw UnimplementedError('RegisterAs.$registerAs is not implemented');
      }
    }

    return get<T>();
  }

  /// Gets or registers an async dependency with optimized lazy loading.
  ///
  /// **Note**: Due to GetIt's internal implementation, async registration methods
  /// may have limitations. For the most reliable behavior, consider using
  /// `RegisterAs.singletonAsync` when you need consistent instance reuse.
  ///
  /// [instanceCreator] - Async function that creates the instance
  /// [registerAs] - Type of registration (factoryAsync, lazySingletonAsync, singletonAsync)
  ///
  /// Returns a Future with the dependency instance.
  Future<T> getOrRegisterAsync<T extends Object>(
    Future<T> Function() instanceCreator,
    RegisterAs registerAs,
  ) async {
    switch (registerAs) {
      case RegisterAs.factoryAsync:
        // For factory async, register and return
        registerFactoryAsync<T>(instanceCreator);
        return await getAsync<T>();
      case RegisterAs.lazySingletonAsync:
        // For lazy singleton async, register and return
        registerLazySingletonAsync<T>(instanceCreator);
        return await getAsync<T>();
      case RegisterAs.singletonAsync:
        // For singleton async, check if already registered
        if (!isRegistered<T>()) {
          final T instance = await instanceCreator();
          registerSingleton<T>(instance);
        }
        return get<T>();
      default:
        throw UnimplementedError(
          'RegisterAs.$registerAs is not implemented for async operations',
        );
    }
  }

  /// Optimized method for factory registration (most common use case).
  ///
  /// Creates a new instance each time the dependency is requested.
  T getOrRegisterFactory<T extends Object>(T Function() instanceCreator) =>
      getOrRegister<T>(instanceCreator, RegisterAs.factory);

  /// Optimized method for lazy singleton registration.
  ///
  /// Creates the instance on first use, then reuses it for subsequent requests.
  T getOrRegisterLazySingleton<T extends Object>(
    T Function() instanceCreator,
  ) => getOrRegister<T>(instanceCreator, RegisterAs.lazySingleton);

  /// Optimized method for singleton registration.
  ///
  /// Creates the instance immediately and reuses it for all subsequent requests.
  T getOrRegisterSingleton<T extends Object>(T Function() instanceCreator) =>
      getOrRegister<T>(instanceCreator, RegisterAs.singleton);

  /// Optimized method for async factory registration.
  ///
  /// Creates a new async instance each time the dependency is requested.
  Future<T> getOrRegisterFactoryAsync<T extends Object>(
    Future<T> Function() instanceCreator,
  ) => getOrRegisterAsync<T>(instanceCreator, RegisterAs.factoryAsync);

  /// Optimized method for async lazy singleton registration.
  ///
  /// Creates the async instance on first use, then reuses it for subsequent requests.
  Future<T> getOrRegisterLazySingletonAsync<T extends Object>(
    Future<T> Function() instanceCreator,
  ) => getOrRegisterAsync<T>(instanceCreator, RegisterAs.lazySingletonAsync);

  /// Optimized method for async singleton registration.
  ///
  /// Creates the async instance immediately and reuses it for all subsequent requests.
  Future<T> getOrRegisterSingletonAsync<T extends Object>(
    Future<T> Function() instanceCreator,
  ) => getOrRegisterAsync<T>(instanceCreator, RegisterAs.singletonAsync);
}
