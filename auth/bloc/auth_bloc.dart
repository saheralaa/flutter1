import 'package:bloc/bloc.dart';
import 'package:project1/auth/auth_provider.dart';
import 'package:project1/auth/bloc/auth_event.dart';
import 'package:project1/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnInitialized(isLoading: true)) {
    on<AuthEventSholdRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLaoding: false,
      ));
    });
    //!SendEmailVerifyCation
    on<AuthEventSendEmailVerifycation>(
      (event, emit) async {
        await provider.sendEmailVerifycation();
        emit(state);
      },
    );
    //? Regester
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.creatuser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerifycation();
        emit(const AuthStateNeedVerification(isLaoding: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLaoding: false));
      }
    });
    //?forgotPassword
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSendEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSendEmail: false,
        isLoading: true,
      ));
      bool didsendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didsendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didsendEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        exception: exception,
        hasSendEmail: didsendEmail,
        isLoading: false,
      ));
    });
    //?initalize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initalize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggout(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerify) {
        emit(const AuthStateNeedVerification(isLaoding: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLaoding: false));
      }
    });
    //! login
    on<AuthEventLogin>((event, emit) async {
      emit(
        const AuthStateLoggout(
            exception: null,
            isLoading: true,
            loadingText: 'Please Wait While I log you in '),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerify) {
          emit(
            const AuthStateLoggout(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedVerification(isLaoding: false));
        } else {
          emit(
            const AuthStateLoggout(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user: user, isLaoding: false));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggout(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    //! log out
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logout();
        emit(
          const AuthStateLoggout(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggout(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}
