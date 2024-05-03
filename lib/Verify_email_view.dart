import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(' Please Veirfy Your email '),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text(' Send Email Veirfycation '),
          )
        ],
      ),
    );
  }
}
