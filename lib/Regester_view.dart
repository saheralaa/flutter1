import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Register'),
      ),
      body: Column(
        children: [
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
            decoration:
                const InputDecoration(hintText: ' Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCreation =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(userCreation);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'Password should be at least 6 characters') {
                  print('Please Enter a Strong Password');
                } else if (e.code ==
                    'The email address is already in use by another account.') {
                  print('This Email is already is used by anouther account');
                } else if (e.code == 'invalid-email') {
                  print('Invalid email entred');
                }
              }
            },
            child: const Text('Regester'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/Login/',
                (route) => false,
              );
            },
            child: const Text('Already Register ? Login Here'),
          ),
        ],
      ),
    );
  }
}
