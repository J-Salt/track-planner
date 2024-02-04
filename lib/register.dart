import 'package:flutter/material.dart';
import 'auth.dart';

class Register extends StatelessWidget {
  Register({super.key});

  void _register(email, password) async {
    await Auth().createUser(email: email, password: password);
  }

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Register Page")),
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
              TextButton(
                  onPressed: () => _register(emailController.value.text,
                      passwordController.value.text),
                  child: const Text("Create Account"))
            ],
          ),
        ),
      ),
    );
  }
}
