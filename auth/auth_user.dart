import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerify;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerify,
  });
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email!,
        isEmailVerify: user.emailVerified,
        id: user.uid,
      );
}
