// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/auth/bloc/auth_bloc.dart';
import 'package:project1/auth/bloc/auth_event.dart';
import 'package:project1/auth/bloc/auth_state.dart';
import 'package:project1/auth/auth_exception.dart';
import 'package:project1/utilites/dialogs/error_dialog.dart';

class RegsterView extends StatefulWidget {
  const RegsterView({super.key});

  @override
  State<RegsterView> createState() => _RegsterViewState();
}

class _RegsterViewState extends State<RegsterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordFoundAuthException) {
            await showErorrDialog(
              context,
              'Waek Password',
            );
          } else if (state.exception is EmailALreadyExceptionsAuthException) {
            await showErorrDialog(
              context,
              'Email Already in use',
            );
          } else if (state.exception is GenericAuthException) {
            await showErorrDialog(
              context,
              'Faild to register',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErorrDialog(
              context,
              'Invalid email',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your email and password to see your notes'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autofocus: true,
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventRegister(
                                email,
                                password,
                              ),
                            );
                      },
                      child: const Text('Regester'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogout(),
                            );
                      },
                      child: const Text('Already Register ? Login Here'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
