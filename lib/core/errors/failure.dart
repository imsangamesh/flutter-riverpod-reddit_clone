import 'package:firebase_auth/firebase_auth.dart';

class Failure {
  Failure(this.message);

  factory Failure.general() =>
      Failure('Something went wrong, please try again later');

  factory Failure.fromFirebase(FirebaseAuthException e) =>
      Failure('${e.code} | ${e.message}');

  final String message;
}
