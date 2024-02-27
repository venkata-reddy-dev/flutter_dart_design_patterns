import 'package:flutter_test/flutter_test.dart';

/// Theory: The Singleton Pattern ensures a class has a single globally accessible instance.

///--- Singleton pattern implementation as per THEORY ---

class AuthService {
  /// static variable which holds Instance of [AuthService]
  static final AuthService instance = AuthService._();

  /// private constructor
  AuthService._();
}

///--- Test cases ---

void main() {
  final authService1 = AuthService.instance;
  final authService2 = AuthService.instance;

  test('Both objects are identical', () {
    expect(identical(authService1, authService2), isTrue);
  });
}

