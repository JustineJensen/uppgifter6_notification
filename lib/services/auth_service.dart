import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uppgift3_new_app/main.dart';
import 'package:uppgift3_new_app/views/home.dart';

class AuthService {
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );

    } catch (e) {
     throw Exception("");
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(title: 'Parking App',),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }

          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );

    } catch (e) {
      throw Exception("");
    }
  }

  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }
}