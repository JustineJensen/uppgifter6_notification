import 'package:flutter/material.dart';
import 'package:uppgift3_new_app/views/signup_view.dart';
import 'package:uppgift3_new_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _emailAddress(),
              const SizedBox(height: 16),
              _password(),
              const SizedBox(height: 16),
              _signin(context),
              const SizedBox(height: 12),
              _signupButton(context),
              const SizedBox(height: 20),
              FutureBuilder<User?>(
                future: _getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final user = snapshot.data!;
                      return Text(
                        ' ${user.displayName ?? 'Guest'}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return const SizedBox.shrink(); 
                    }
                  } else {
                    return const CircularProgressIndicator(); 
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
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
          obscureText: true,
          controller: _passwordController,
          decoration: const InputDecoration(
            hintText: 'Enter your password',
          ),
        ),
      ],
    );
  }

  Widget _signin(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signin(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
      },
      child: const Text('Sign in'),
    );
  }

  Widget _signupButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupScreen()),
        );
      },
      child: const Text('Don’t have an account? Sign up'),
    );
  }
}
