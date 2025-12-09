import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_lazyload/get_it_lazyload.dart';

void main() {
  group('GetItExtension Tests', () {
    late GetIt getIt;

    setUp(() {
      getIt = GetIt.instance;
    });

    tearDown(() {
      getIt.reset();
    });

    group('getOrRegister Tests', () {
      test('should register and return singleton', () {
        final service = getIt.getOrRegister<TestService>(
          () => TestService('test'),
          RegisterAs.singleton,
        );

        expect(service.name, 'test');
        expect(getIt.isRegistered<TestService>(), true);

        // Should return same instance
        final service2 = getIt.get<TestService>();
        expect(identical(service, service2), true);
      });

      test('should register and return factory', () {
        // For factory, we need to call get() multiple times to get different instances
        getIt.getOrRegister<TestService>(
          () => TestService('test'),
          RegisterAs.factory,
        );

        final service1 = getIt.get<TestService>();
        final service2 = getIt.get<TestService>();

        expect(service1.name, 'test');
        expect(service2.name, 'test');
        expect(getIt.isRegistered<TestService>(), true);

        // Should return different instances for factory
        expect(identical(service1, service2), false);
      });

      test('should register and return lazy singleton', () {
        final service = getIt.getOrRegister<TestService>(
          () => TestService('test'),
          RegisterAs.lazySingleton,
        );

        expect(service.name, 'test');
        expect(getIt.isRegistered<TestService>(), true);

        // Should return same instance
        final service2 = getIt.get<TestService>();
        expect(identical(service, service2), true);
      });

      test('should return existing instance if already registered', () {
        // Register first
        final service1 = getIt.getOrRegister<TestService>(
          () => TestService('test1'),
          RegisterAs.singleton,
        );

        // Try to register again with different name
        final service2 = getIt.getOrRegister<TestService>(
          () => TestService('test2'),
          RegisterAs.singleton,
        );

        // Should return first instance
        expect(identical(service1, service2), true);
        expect(service2.name, 'test1');
      });
    });

    group('getOrRegisterAsync Tests', () {
      test('should register and return async singleton', () async {
        final service = await getIt.getOrRegisterAsync<AsyncTestService>(
          () async => await AsyncTestService.create('test'),
          RegisterAs.singletonAsync,
        );

        expect(service.name, 'test');
        expect(getIt.isRegistered<AsyncTestService>(), true);

        // Should return same instance
        final service2 = getIt.get<AsyncTestService>();
        expect(identical(service, service2), true);
      });

      test('should register and return async factory', () async {
        final service = await getIt.getOrRegisterAsync<AsyncTestService>(
          () async => await AsyncTestService.create('test'),
          RegisterAs.factoryAsync,
        );

        expect(service.name, 'test');
      });

      test('should register and return async lazy singleton', () async {
        final service = await getIt.getOrRegisterAsync<AsyncTestService>(
          () async => await AsyncTestService.create('test'),
          RegisterAs.lazySingletonAsync,
        );

        expect(service.name, 'test');
      });

      test(
        'should throw error for unsupported async RegisterAs type',
        () async {
          expect(
            () => getIt.getOrRegisterAsync<AsyncTestService>(
              () async => await AsyncTestService.create('test'),
              RegisterAs.singleton, // Not an async type
            ),
            throwsUnimplementedError,
          );
        },
      );
    });

    group('Convenience Methods Tests', () {
      test('getOrRegisterFactory should work correctly', () {
        final service = getIt.getOrRegisterFactory<TestService>(
          () => TestService('test'),
        );

        expect(service.name, 'test');
        expect(getIt.isRegistered<TestService>(), true);
      });

      test('getOrRegisterLazySingleton should work correctly', () {
        final service = getIt.getOrRegisterLazySingleton<TestService>(
          () => TestService('test'),
        );

        expect(service.name, 'test');
        expect(getIt.isRegistered<TestService>(), true);
      });

      test('getOrRegisterSingleton should work correctly', () {
        final service = getIt.getOrRegisterSingleton<TestService>(
          () => TestService('test'),
        );

        expect(service.name, 'test');
        expect(getIt.isRegistered<TestService>(), true);
      });

      test('getOrRegisterFactoryAsync should work correctly', () async {
        final service = await getIt.getOrRegisterFactoryAsync<AsyncTestService>(
          () async => await AsyncTestService.create('test'),
        );

        expect(service.name, 'test');
      });

      test('getOrRegisterLazySingletonAsync should work correctly', () async {
        final service = await getIt
            .getOrRegisterLazySingletonAsync<AsyncTestService>(
              () async => await AsyncTestService.create('test'),
            );

        expect(service.name, 'test');
      });

      test('getOrRegisterSingletonAsync should work correctly', () async {
        final service = await getIt
            .getOrRegisterSingletonAsync<AsyncTestService>(
              () async => await AsyncTestService.create('test'),
            );

        expect(service.name, 'test');
        expect(getIt.isRegistered<AsyncTestService>(), true);
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      test('should handle multiple registrations of same type', () {
        // Register same type multiple times
        final service1 = getIt.getOrRegister<TestService>(
          () => TestService('test1'),
          RegisterAs.singleton,
        );

        final service2 = getIt.getOrRegister<TestService>(
          () => TestService('test2'),
          RegisterAs.singleton,
        );

        // Should return same instance
        expect(identical(service1, service2), true);
        expect(service2.name, 'test1');
      });

      test(
        'should handle async singleton with existing registration',
        () async {
          // Register first
          final service1 = await getIt.getOrRegisterAsync<AsyncTestService>(
            () async => await AsyncTestService.create('test1'),
            RegisterAs.singletonAsync,
          );

          // Try to register again
          final service2 = await getIt.getOrRegisterAsync<AsyncTestService>(
            () async => await AsyncTestService.create('test2'),
            RegisterAs.singletonAsync,
          );

          // Should return same instance
          expect(identical(service1, service2), true);
          expect(service2.name, 'test1');
        },
      );

      test('should handle different types with same registration pattern', () {
        final service1 = getIt.getOrRegister<TestService>(
          () => TestService('test1'),
          RegisterAs.singleton,
        );

        final service2 = getIt.getOrRegister<AnotherTestService>(
          () => AnotherTestService('test2'),
          RegisterAs.singleton,
        );

        expect(service1.name, 'test1');
        expect(service2.name, 'test2');
        expect(getIt.isRegistered<TestService>(), true);
        expect(getIt.isRegistered<AnotherTestService>(), true);
      });

      test(
        'should throw UnimplementedError for unsupported RegisterAs type',
        () {
          // Test the default case in the switch statement using the
          // testUnsupported enum value marked with @visibleForTesting.
          // This ensures 100% code coverage.
          expect(
            () => getIt.getOrRegister<TestService>(
              () => TestService('test'),
              RegisterAs.testUnsupported,
            ),
            throwsA(
              isA<UnimplementedError>().having(
                (e) => e.message,
                'message',
                contains('RegisterAs.testUnsupported is not implemented'),
              ),
            ),
          );
        },
      );
    });
  });
}

class TestService {
  final String name;

  TestService(this.name);
}

class AnotherTestService {
  final String name;

  AnotherTestService(this.name);
}

class AsyncTestService {
  final String name;

  AsyncTestService._(this.name);

  static Future<AsyncTestService> create(String name) async {
    // Simulate async initialization
    await Future.delayed(Duration(milliseconds: 10));
    return AsyncTestService._(name);
  }
}
