import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/auth/bloc/auth_bloc.dart';
import 'package:project1/auth/bloc/auth_event.dart';


class VeirifyEmailview extends StatefulWidget {
  const VeirifyEmailview({super.key});

  @override
  State<VeirifyEmailview> createState() => _VeirifyEmailviewState();
}

class _VeirifyEmailviewState extends State<VeirifyEmailview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
            "We've send you an email verifycation .Please open it to verify your account.",
          ),
          const Text(
            "if you haven't recevied  a verifycation email yet,press the button below",
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerifycation(),
                  );
            },
            child: const Text(' Send Email Veirfycation '),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventLogout(),
                  );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
