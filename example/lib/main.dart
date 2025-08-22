import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_lazyload/get_it_lazyload.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

void setupDependencies() {
  final getIt = GetIt.instance;

  // Only register core dependencies that are needed immediately
  getIt.getOrRegister<ConfigService>(
    () => ConfigService(),
    RegisterAs.singleton,
  );

  // Other dependencies will be registered lazily when first accessed
  // No need to register AuthRepository, AnonymousAuthUseCase, etc. here
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetIt LazyLoad Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LazyLoadingExample(),
    );
  }
}

class LazyLoadingExample extends StatefulWidget {
  const LazyLoadingExample({super.key});

  @override
  State<LazyLoadingExample> createState() => _LazyLoadingExampleState();
}

class _LazyLoadingExampleState extends State<LazyLoadingExample> {
  String _output = '';

  void _testLazyLoading() async {
    setState(() {
      _output = 'Testing lazy loading pattern...\n\n';
    });

    try {
      // Example 1: Lazy loading UseCase with Factory pattern
      _output += '=== Example 1: AnonymousAuthUseCase ===\n';
      final authUseCase1 = AnonymousAuthUseCase.get();
      final authUseCase2 = AnonymousAuthUseCase.get();
      _output += 'UseCase1: ${authUseCase1.runtimeType}\n';
      _output += 'UseCase2: ${authUseCase2.runtimeType}\n';
      _output += 'Same instance: ${identical(authUseCase1, authUseCase2)}\n\n';

      // Example 2: Lazy loading Repository with LazySingleton pattern
      _output += '=== Example 2: AuthRepository ===\n';
      final repo1 = AuthRepository.get();
      final repo2 = AuthRepository.get();
      _output += 'Repo1: ${repo1.runtimeType}\n';
      _output += 'Repo2: ${repo2.runtimeType}\n';
      _output += 'Same instance: ${identical(repo1, repo2)}\n\n';

      // Example 3: Lazy loading Service with Singleton pattern
      _output += '=== Example 3: DatabaseService ===\n';
      final db1 = DatabaseService.get();
      final db2 = DatabaseService.get();
      _output += 'DB1: ${db1.runtimeType}\n';
      _output += 'DB2: ${db2.runtimeType}\n';
      _output += 'Same instance: ${identical(db1, db2)}\n\n';

      // Example 4: Async lazy loading
      _output += '=== Example 4: AsyncService ===\n';
      final asyncService1 = await AsyncService.get();
      final asyncService2 = await AsyncService.get();
      _output += 'AsyncService1: ${asyncService1.name}\n';
      _output += 'AsyncService2: ${asyncService2.name}\n';
      _output +=
          'Same instance: ${identical(asyncService1, asyncService2)}\n\n';

      // Example 5: Direct extension usage
      _output += '=== Example 5: Direct Extension Usage ===\n';
      final directService = GetIt.instance.getOrRegister<DirectService>(
        () => DirectService(),
        RegisterAs.lazySingleton,
      );
      _output += 'DirectService: ${directService.name}\n';
    } catch (e) {
      _output += 'Error: $e\n';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lazy Loading Pattern Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testLazyLoading,
              child: const Text('Test Lazy Loading Pattern'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _output.isEmpty
                        ? 'Click "Test Lazy Loading Pattern" to see results'
                        : _output,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example UseCase with Factory pattern (creates new instance each time)
class AnonymousAuthUseCase {
  final AuthRepository _repository;

  AnonymousAuthUseCase(this._repository);

  Future<FirebaseUserModel> execute() {
    return _repository.signInAnonymously();
  }

  static AnonymousAuthUseCase get() {
    return GetIt.instance.getOrRegister<AnonymousAuthUseCase>(
      () => AnonymousAuthUseCase(AuthRepository.get()),
      RegisterAs.factory,
    );
  }
}

// Example Repository with LazySingleton pattern (reuses instance)
class AuthRepository {
  final DatabaseService _database;

  AuthRepository(this._database);

  Future<FirebaseUserModel> signInAnonymously() async {
    // Simulate async operation using the database service
    await Future.delayed(const Duration(milliseconds: 100));
    // Use the database service to show it's not unused
    final connectionId = _database.connectionId;
    return FirebaseUserModel(
      id: 'anonymous_${DateTime.now().millisecondsSinceEpoch}_$connectionId',
    );
  }

  static AuthRepository get() {
    return GetIt.instance.getOrRegister<AuthRepository>(
      () => AuthRepository(DatabaseService.get()),
      RegisterAs.lazySingleton,
    );
  }
}

// Example Service with Singleton pattern (created immediately)
class DatabaseService {
  final String connectionId = 'db_${DateTime.now().millisecondsSinceEpoch}';

  DatabaseService() {
    // In a real app, you might log this instead of print
    debugPrint('DatabaseService created with connection: $connectionId');
  }

  static DatabaseService get() {
    return GetIt.instance.getOrRegister<DatabaseService>(
      () => DatabaseService(),
      RegisterAs.singleton,
    );
  }
}

// Example Async Service with SingletonAsync pattern
class AsyncService {
  final String name;

  AsyncService._(this.name);

  static Future<AsyncService> get() async {
    return await GetIt.instance.getOrRegisterAsync<AsyncService>(
      () async => await AsyncService.initialize(),
      RegisterAs.singletonAsync,
    );
  }

  static Future<AsyncService> initialize() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In a real app, you might log this instead of print
    debugPrint('AsyncService initialized');
    return AsyncService._(
      'Async Service ${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

// Example direct extension usage
class DirectService {
  final String name = 'Direct Service ${DateTime.now().millisecondsSinceEpoch}';
}

// Example model
class FirebaseUserModel {
  final String id;

  FirebaseUserModel({required this.id});

  @override
  String toString() => 'FirebaseUserModel(id: $id)';
}

// Example configuration service (registered at startup)
class ConfigService {
  final String config = 'App Configuration';

  ConfigService() {
    // In a real app, you might log this instead of print
    debugPrint('ConfigService created');
  }
}
