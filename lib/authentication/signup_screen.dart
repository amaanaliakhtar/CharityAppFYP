import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(children: [
              Image(
                image: AssetImage('assets/login-image.png'),
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const Text("Welcome!"),
              const Text("Dontate where you want, when you want."),
            ]),
          ),
        ),
      ),
    );
  }
}
