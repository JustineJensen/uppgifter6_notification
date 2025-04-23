import 'package:flutter/material.dart';
import 'package:uppgift3_new_app/main.dart';
import 'package:uppgift3_new_app/services/auth_service.dart';
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signin(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
               const SizedBox(height: 16),
              _name(),
              const SizedBox(height: 16),
              _emailAddress(),
              const SizedBox(height: 16),
              _password(),
              const SizedBox(height: 16),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email address'),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Enter your email address',
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password'),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter your password',
          ),
        ),
      ],
    );
  }
  Widget _name() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Name'),
      TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Enter your full name',
        ),
      ),
    ],
  );
}

  Widget _signup(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signup(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
          name: _nameController.text,
        );
      },
      child: const Text('Sign up'),
    );
  }

  Widget _signin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(),
              ),
            );
          },
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}