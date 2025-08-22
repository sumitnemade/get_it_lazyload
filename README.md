# get_it_lazyload

[![Pub Version](https://img.shields.io/pub/v/get_it_lazyload)](https://pub.dev/packages/get_it_lazyload)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Test Coverage](https://img.shields.io/badge/coverage-97.22%25-brightgreen)](https://github.com/sumitnemade/get_it_lazyload)

A Flutter package providing optimized lazy loading extensions for GetIt dependency injection with comprehensive support for all registration types and async dependencies.

## ✨ Features

- **🚀 Optimized Lazy Loading**: Efficient dependency registration with automatic instance creation
- **🔄 Multiple Registration Types**: Support for factory, singleton, and lazy singleton patterns
- **⚡ Async Support**: Full support for asynchronous dependency initialization
- **🎯 Performance Optimized**: Minimal overhead with smart registration checking
- **🛡️ Type Safe**: Full type safety with generic methods
- **🧪 Well Tested**: 97.22% test coverage ensuring reliability

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  get_it_lazyload: ^0.0.1
  get_it: ^8.2.0
```

Then run:
```bash
flutter pub get
```

## 🚀 Quick Start

```dart
import 'package:get_it/get_it.dart';
import 'package:get_it_lazyload/get_it_lazyload.dart';

final getIt = GetIt.instance;

// Register a service with automatic lazy loading
final service = getIt.getOrRegister<MyService>(
  () => MyService(), 
  RegisterAs.singleton
);
```

## 📚 Usage

### Basic Usage

```dart
import 'package:get_it/get_it.dart';
import 'package:get_it_lazyload/get_it_lazyload.dart';

final getIt = GetIt.instance;

// Register a service with automatic lazy loading
getIt.getOrRegister<MyService>(() => MyService(), RegisterAs.singleton);

// Get the service (will be created if not registered)
final service = getIt.get<MyService>();
```

### Lazy Loading Pattern for Use Cases and Repositories

The main benefit of this package is avoiding eager registration of dependencies at app startup. Instead, dependencies are loaded and registered only when they're actually required:

```dart
// UseCase with Factory pattern (creates new instance each time)
class AnonymousAuthUseCase {
  final AuthRepository _repository;

  AnonymousAuthUseCase(this._repository);

  Future<FirebaseUserModel> execute() {
    return _repository.signInAnonymously();
  }

  static AnonymousAuthUseCase get() {
    return GetIt.instance.getOrRegister<AnonymousAuthUseCase>(
        () => AnonymousAuthUseCase(AuthRepository.get()), 
        RegisterAs.factory);
  }
}

// Repository with LazySingleton pattern (reuses instance)
class AuthRepository {
  final DatabaseService _database;

  AuthRepository(this._database);

  Future<FirebaseUserModel> signInAnonymously() async {
    return _database.createAnonymousUser();
  }

  static AuthRepository get() {
    return GetIt.instance.getOrRegister<AuthRepository>(
        () => AuthRepository(DatabaseService.get()), 
        RegisterAs.lazySingleton);
  }
}

// Service with Singleton pattern (created immediately when first accessed)
class DatabaseService {
  static DatabaseService get() {
    return GetIt.instance.getOrRegister<DatabaseService>(
        () => DatabaseService(), 
        RegisterAs.singleton);
  }
}
```

**Benefits of this pattern:**
- ✅ Dependencies are created only when needed
- ✅ No eager registration at app startup
- ✅ Automatic dependency resolution
- ✅ Clean separation of concerns
- ✅ Easy to test and mock

### Registration Types

#### Singleton
Creates instance immediately and reuses it:

```dart
getIt.getOrRegister<ConfigService>(
  () => ConfigService(), 
  RegisterAs.singleton
);
```

#### Factory
Creates new instance each time:

```dart
getIt.getOrRegister<DataModel>(
  () => DataModel(), 
  RegisterAs.factory
);
```

#### Lazy Singleton
Creates instance on first use, then reuses it:

```dart
getIt.getOrRegister<ExpensiveService>(
  () => ExpensiveService(), 
  RegisterAs.lazySingleton
);
```

### Async Dependencies

#### Async Factory
```dart
final service = await getIt.getOrRegisterAsync<AsyncService>(
  () async => await AsyncService.initialize(), 
  RegisterAs.factoryAsync
);
```

#### Async Lazy Singleton
```dart
final service = await getIt.getOrRegisterAsync<AsyncService>(
  () async => await AsyncService.initialize(), 
  RegisterAs.lazySingletonAsync
);
```

#### Async Singleton
```dart
final service = await getIt.getOrRegisterAsync<AsyncService>(
  () async => await AsyncService.initialize(), 
  RegisterAs.singletonAsync
);
```

### Convenience Methods

For common use cases, you can use these convenience methods:

```dart
// Factory registration
getIt.getOrRegisterFactory<DataModel>(() => DataModel());

// Lazy singleton registration
getIt.getOrRegisterLazySingleton<Service>(() => Service());

// Singleton registration
getIt.getOrRegisterSingleton<Config>(() => Config());

// Async variants
await getIt.getOrRegisterFactoryAsync<AsyncService>(
  () async => await AsyncService.initialize()
);

await getIt.getOrRegisterLazySingletonAsync<AsyncService>(
  () async => await AsyncService.initialize()
);

await getIt.getOrRegisterSingletonAsync<AsyncService>(
  () async => await AsyncService.initialize()
);
```

## 📖 API Reference

### RegisterAs Enum

- `RegisterAs.singleton` - Creates instance immediately and reuses it
- `RegisterAs.factory` - Creates new instance each time
- `RegisterAs.lazySingleton` - Creates instance on first use, then reuses it
- `RegisterAs.factoryAsync` - Creates new async instance each time
- `RegisterAs.lazySingletonAsync` - Creates async instance on first use, then reuses it
- `RegisterAs.singletonAsync` - Creates async instance immediately and reuses it

### GetItExtension Methods

- `getOrRegister<T>()` - Gets or registers a dependency
- `getOrRegisterAsync<T>()` - Gets or registers an async dependency
- `getOrRegisterFactory<T>()` - Gets or registers as factory
- `getOrRegisterLazySingleton<T>()` - Gets or registers as lazy singleton
- `getOrRegisterSingleton<T>()` - Gets or registers as singleton
- `getOrRegisterFactoryAsync<T>()` - Gets or registers as async factory
- `getOrRegisterLazySingletonAsync<T>()` - Gets or registers as async lazy singleton
- `getOrRegisterSingletonAsync<T>()` - Gets or registers as async singleton

## 🚀 Performance Benefits

- **Single Registration Check**: Only checks if dependency is registered once per call
- **Optimized Registration**: Direct function registration without extra wrapping
- **Lazy Initialization**: Dependencies are only created when needed
- **Memory Efficient**: Reuses instances where appropriate
- **Startup Performance**: No eager registration means faster app startup

## ⚠️ Important Notes

### Async Registration Behavior

Due to GetIt's internal implementation of async registrations, there are some limitations to be aware of:

1. **Async Factory**: Works as expected - creates new instances each time
2. **Async Lazy Singleton**: May create new instances on subsequent calls due to GetIt's async registration behavior
3. **Async Singleton**: Works as expected - creates instance once and reuses it

For the most reliable behavior with async dependencies, consider using `RegisterAs.singletonAsync` when you need consistent instance reuse.

### Best Practices

- Use sync registration methods when possible for better performance
- Reserve async registration for dependencies that truly require async initialization
- Test your dependency injection setup thoroughly, especially with async services
- Consider using `RegisterAs.singletonAsync` for services that should be shared across your app
- Use the lazy loading pattern for UseCases and Repositories to avoid eager registration
- Only register core dependencies (like config) at app startup

## 📱 Example

Check out the [example app](example/) for a complete working demonstration of the lazy loading pattern.

```dart
import 'package:get_it/get_it.dart';
import 'package:get_it_lazyload/get_it_lazyload.dart';

class MyApp {
  static void setupDependencies() {
    final getIt = GetIt.instance;
    
    // Only register core dependencies that are needed immediately
    getIt.getOrRegister<ConfigService>(
      () => ConfigService(), 
      RegisterAs.singleton
    );
    
    // Other dependencies will be registered lazily when first accessed
    // No need to register AuthRepository, AnonymousAuthUseCase, etc. here
  }
}
```

## 🧪 Testing

The package includes comprehensive tests with 97.22% coverage:

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on top of the excellent [GetIt](https://pub.dev/packages/get_it) package
- Inspired by clean architecture principles and dependency injection best practices
- Community feedback and contributions

## 📊 Package Health

- ✅ **Test Coverage**: 97.22%
- ✅ **Static Analysis**: Passing
- ✅ **Documentation**: Complete
- ✅ **Examples**: Included
- ✅ **License**: MIT
- ✅ **Platform Support**: Flutter (iOS, Android, Web, Desktop)
