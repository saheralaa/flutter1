import 'package:flutter/foundation.dart' show immutable;
import 'package:project1/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait...',
  });
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLaoding,
  }) : super(isLoading: isLaoding);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSendEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSendEmail,
    required bool isLoading,
  }):super(isLoading:isLoading);  
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isLaoding})
      : super(isLoading: isLaoding);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required bool isLaoding})
      : super(isLoading: isLaoding);
}

class AuthStateLoggout extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggout({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}
