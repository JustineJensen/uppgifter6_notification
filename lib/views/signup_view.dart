import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/auth/auth_bloc.dart';
import 'package:uppgift3_new_app/repositories/notification_repository.dart';
import 'package:uppgift3_new_app/views/home.dart';

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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  Home(title: 'Parking App')),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sign up', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _name(),
                  const SizedBox(height: 16),
                  _emailAddress(),
                  const SizedBox(height: 16),
                  _password(),
                  const SizedBox(height: 16),
                  _signup(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name'),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter your full name'),
        ),
      ],
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

  Widget _signup(BuildContext context, AuthState state) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(
              AuthRegister(
                username: _nameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            );
      },
      child: state is AuthInProgress
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('Sign up'),
    );
  }

  Widget _signin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}
