/// A Flutter package providing optimized lazy loading extensions for GetIt dependency injection.
///
/// This package extends GetIt with convenient methods for getting or registering dependencies
/// with automatic lazy loading, ensuring optimal performance and clean dependency management.
///
/// ## Features
///
/// - **🚀 Optimized Lazy Loading**: Efficient dependency registration with automatic instance creation
/// - **🔄 Multiple Registration Types**: Support for factory, singleton, and lazy singleton patterns
/// - **⚡ Async Support**: Full support for asynchronous dependency initialization
/// - **🎯 Performance Optimized**: Minimal overhead with smart registration checking
/// - **🛡️ Type Safe**: Full type safety with generic methods
///
/// ## Quick Start
///
/// ```dart
/// import 'package:get_it/get_it.dart';
/// import 'package:get_it_lazyload/get_it_lazyload.dart';
///
/// final getIt = GetIt.instance;
///
/// // Register a service with automatic lazy loading
/// final service = getIt.getOrRegister<MyService>(
///   () => MyService(), 
///   RegisterAs.singleton
/// );
/// ```
///
/// ## Usage Patterns
///
/// ### Lazy Loading Pattern for Use Cases and Repositories
///
/// The main benefit of this package is avoiding eager registration of dependencies at app startup.
/// Instead, dependencies are loaded and registered only when they're actually required:
///
/// ```dart
/// // UseCase with Factory pattern (creates new instance each time)
/// class AnonymousAuthUseCase {
///   final AuthRepository _repository;
///
///   AnonymousAuthUseCase(this._repository);
///
///   Future<FirebaseUserModel> execute() {
///     return _repository.signInAnonymously();
///   }
///
///   static AnonymousAuthUseCase get() {
///     return GetIt.instance.getOrRegister<AnonymousAuthUseCase>(
///         () => AnonymousAuthUseCase(AuthRepository.get()), 
///         RegisterAs.factory);
///   }
/// }
///
/// // Repository with LazySingleton pattern (reuses instance)
/// class AuthRepository {
///   final DatabaseService _database;
///
///   AuthRepository(this._database);
///
///   Future<FirebaseUserModel> signInAnonymously() async {
///     return _database.createAnonymousUser();
///   }
///
///   static AuthRepository get() {
///     return GetIt.instance.getOrRegister<AuthRepository>(
///         () => AuthRepository(DatabaseService.get()), 
///         RegisterAs.lazySingleton);
///   }
/// }
/// ```
///
/// ## Registration Types
///
/// - `RegisterAs.singleton` - Creates instance immediately and reuses it
/// - `RegisterAs.factory` - Creates new instance each time
/// - `RegisterAs.lazySingleton` - Creates instance on first use, then reuses it
/// - `RegisterAs.factoryAsync` - Creates new async instance each time
/// - `RegisterAs.lazySingletonAsync` - Creates async instance on first use, then reuses it
/// - `RegisterAs.singletonAsync` - Creates async instance immediately and reuses it
///
/// ## Performance Benefits
///
/// - **Single Registration Check**: Only checks if dependency is registered once per call
/// - **Optimized Registration**: Direct function registration without extra wrapping
/// - **Lazy Initialization**: Dependencies are only created when needed
/// - **Memory Efficient**: Reuses instances where appropriate
/// - **Startup Performance**: No eager registration means faster app startup
///
/// For more information, see the [README](https://github.com/sumitnemade/get_it_lazyload#readme).
library;

export 'src/get_it_extension.dart';
export 'src/register_as.dart';
