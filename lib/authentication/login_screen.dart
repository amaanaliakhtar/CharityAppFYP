import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('assets/login-image.png'),
                  height: size.height * 0.2,
                ),
                const Text("Welcome!"),
                const Text("Dontate where you want, when you want."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
