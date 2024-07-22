import 'package:flutter/material.dart';
import 'package:project1/auth/bloc/auth_bloc.dart';
import 'package:project1/auth/bloc/auth_event.dart';
import 'package:project1/auth/bloc/auth_state.dart';
import 'package:project1/auth/auth_exception.dart';
import 'package:project1/utilites/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggout) {
          if (state.exception is UserNotFoundAuthException) {
            await showErorrDialog(
              context,
              'Cannot find a user with the entered credentials!',
            );
          } else if (state.exception is WrongPasswordFoundAuthException) {
            await showErorrDialog(context, 'wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErorrDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please log in to your account in order to interact with and creat notes'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: ' Enter your email here'),
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _password,
                decoration: const InputDecoration(
                    hintText: ' Enter your password here'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogin(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventForgotPassword());
                  },
                  child: const Text('I forgot my password')),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventSholdRegister(),
                      );
                },
                child: const Text('Not Register yet ? Register here '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/**
 
 */