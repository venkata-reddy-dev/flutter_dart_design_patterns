import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

/// Better Approch with Dependency Injection ✅:
///
///     get_it is a popular packge for Dart and Flutter projects
///     to inject dependencies with service locator pattern

///--- Implementation with get_it package ---

class AuthService {
  final FirebaseAuth firebaseAuth;

  /// inject dependency from outside
  AuthService({required this.firebaseAuth});

  void signOut() => firebaseAuth.signOut();
}

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();

  final sl = GetIt.instance;

  /// ✅ register AuthService Instance as singleton
  sl.registerLazySingleton(() => AuthService(firebaseAuth: mockFirebaseAuth));

  final authService1 = sl<AuthService>();

  /// get AuthService instance from get_it
  final authService2 = sl<AuthService>();

  /// get AuthService instance from get_it

  test('Both objects are identical', () {
    expect(identical(authService1, authService2), isTrue);
  });

  test('called signOut() one time', () {
    when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
    authService1.signOut();
    verify(() => mockFirebaseAuth.signOut()).called(1);
  });

  test('signOut() throws exception ', () {
    when(() => mockFirebaseAuth.signOut()).thenThrow(Exception());
    expect(() => authService1.signOut(), throwsException);
  });
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Note: With this approch dependencies are looslly coupled.
///       and Test cases can be implemented by passing mocked dependencies

