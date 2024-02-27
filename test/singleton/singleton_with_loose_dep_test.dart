import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Scenario-2 :❗ Let's make [FirebaseAuth] as explicit dependency

///--- Implementation as per Scenario-2 ( ❌ not recommended ) ---

class AuthService {
  /// static variable which holds Instance of [AuthService]
  static AuthService? _instance;

  late FirebaseAuth _firebaseAuth;

  /// Private constructor
  AuthService._(FirebaseAuth firebaseAuth) {
    _firebaseAuth = firebaseAuth;
  }

  /// factory constructor which returns exiting object or crates new object and assign to static variable
  factory AuthService.getInstance(FirebaseAuth firebaseAuth) {
    return _instance ??= AuthService._(firebaseAuth);
  }

  void signOut() => _firebaseAuth.signOut();
}

///--- Test cases ---

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();

  /// ❌ Passing dependency every time. not recommended and very bad practice
  final authService1 = AuthService.getInstance(mockFirebaseAuth);
  final authService2 = AuthService.getInstance(mockFirebaseAuth);

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

