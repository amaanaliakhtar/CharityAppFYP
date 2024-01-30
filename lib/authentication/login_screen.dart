import 'package:charity_app/authentication/signup_screen.dart';
import 'package:charity_app/authentication/auth_service.dart';
import 'package:charity_app/home.dart';
import 'package:charity_app/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                  image: const AssetImage('assets/logo.png'),
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Text(
                  "Welcome!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Text("Dontate where you want, when you want."),

                //Form
                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              labelText: "Email",
                              hintText: "Email",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.fingerprint),
                              suffixIcon: Icon(Icons.remove_red_eye_rounded),
                              labelText: "Password",
                              hintText: "Password",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot password?"),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signIn,
                            child: const Text("LOGIN"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text("Register"),
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

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signIn(email, password);

    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    }
  }
}
