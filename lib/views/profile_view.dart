import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<User?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Person logged in: ${user.displayName ?? 'No Name Provided'}', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Email: ${user.email ?? 'No Email Provided'}', 
                    style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _updateUserName(context);
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Update Name'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user is currently logged in.'));
          }
        },
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser; 
  }

  Future<void> _updateUserName(BuildContext context) async {
    final nameController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await user?.updateDisplayName(nameController.text);
                await user?.reload();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}