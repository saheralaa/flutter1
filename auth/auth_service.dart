import 'package:project1/auth/auth_provider.dart';
import 'package:project1/auth/auth_user.dart';
import 'package:project1/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirbaseAuthprovider());
  @override
  Future<AuthUser> creatuser({
    required String email,
    required String password,
  }) =>
      provider.creatuser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerifycation() => provider.sendEmailVerifycation();

  @override
  Future<void> initalize() => provider.initalize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);
}
