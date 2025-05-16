import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/auth/auth_bloc.dart';
import 'package:uppgift3_new_app/views/signup_view.dart';
import 'package:uppgift3_new_app/views/home.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Home(title: 'Parking App')),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.redAccent),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sign in', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _emailAddress(),
                  const SizedBox(height: 16),
                  _password(),
                  const SizedBox(height: 16),
                  _signinButton(context, state),
                  const SizedBox(height: 12),
                  _signupButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _emailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email address'),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(hintText: 'Enter your email address'),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password'),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Enter your password'),
        ),
      ],
    );
  }

  Widget _signinButton(BuildContext context, AuthState state) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(
              AuthLogin(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            );
      },
      child: state is AuthInProgress
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('Sign in'),
    );
  }

  Widget _signupButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen()));
      },
      child: const Text('Don’t have an account? Sign up'),
    );
  }
}
