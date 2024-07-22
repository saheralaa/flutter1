import 'dart:async';
import 'package:project1/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initalize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> creatuser({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerifycation();
  Future<void> sendPasswordReset({required String toEmail});
}
