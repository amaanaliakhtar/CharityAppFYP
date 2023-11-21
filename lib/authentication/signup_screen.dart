import 'package:charity_app/authentication/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: const AssetImage('assets/login-image.png'),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const Text("Welcome!"),
                const Text("Dontate where you want, when you want."),
                //Signup input form
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Full Name"),
                              prefixIcon: Icon(Icons.person_3),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          //sized boxes allow for space between widgets
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Email"),
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Password"),
                              prefixIcon: Icon(Icons.fingerprint),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text("SIGNUP")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already registered?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Sign in"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
