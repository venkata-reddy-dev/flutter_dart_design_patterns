import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

/// Scenario-1 :❗ What if [AuthService] has a tight coupling with some other object
///                for example [FirebaseAuth]

///--- Implementation as per Scenario-1 ---

class AuthService {
  /// static variable which holds Instance of [AuthService]
  static final AuthService instance = AuthService._();

  /// private constructor
  AuthService._();

  ///❗ private dependency. can't be mocked for test cases
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() {
    ///❗ Can't be tested
    return _firebaseAuth.signOut();
  }
}

/// NOTE:❗ signOut() method is harder to test. because [FirebaseAuth] as implicit dependency.


void main() {}
