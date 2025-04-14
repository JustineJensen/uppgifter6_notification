import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uppgift3_new_app/services/auth_service.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(FirebaseAuth.instance.currentUser!.email!.toString()),
              const SizedBox(
                height: 10,
              ),
              _logout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signout(context);
      },
      child: Text("Sign Out"),
    );
  }
}