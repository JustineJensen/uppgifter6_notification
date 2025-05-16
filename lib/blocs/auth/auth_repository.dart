import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name);

   
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "username": name,
      "email": email,
    });

    return user;
  }

 Future<User> signin({
  required String email,
  required String password,
}) async {
  final credential = await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return credential.user!; 
}


  Future<void> signout() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();
}
