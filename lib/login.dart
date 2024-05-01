import 'package:flutter/material.dart';
import 'package:track_planner/main.dart';
import 'package:track_planner/register.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'auth.dart';

class Login extends StatelessWidget {
  Login({super.key});

  //Log out user and replace the page
  void _login(email, password, context) async {
    await Auth().signIn(email: email, password: password);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Login",
        context: context,
        trailingActions: [
          IconButton(
              onPressed: () => _login(emailController.value.text,
                  passwordController.value.text, context),
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (String value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                        hintText: "Email",
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onSubmitted: (String value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                        hintText: "Password",
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      ),
                      child: const Text("Register"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
