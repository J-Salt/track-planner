import 'package:flutter/material.dart';
import 'package:track_planner/main.dart';
import 'package:track_planner/register.dart';
import 'auth.dart';

class Login extends StatelessWidget {
  Login({super.key});

  void _login(email, password, context) async {
    await Auth().signIn(email: email, password: password);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(title: "Home Page")));
  }

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (String value) {
                  email = value;
                },
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                onSubmitted: (String value) {
                  password = value;
                },
              ),
              ElevatedButton(
                onPressed: () => _login(emailController.value.text,
                    passwordController.value.text, context),
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                ),
                child: const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
