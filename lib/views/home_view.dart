import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uppgift3_new_app/blocs/auth/auth_service.dart';
import 'package:uppgift3_new_app/repositories/notification_repository.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationRepo = context.read<NotificationRepository>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hello',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(user?.displayName ?? 'No name available'),
              const SizedBox(height: 10),
              Text(user?.email ?? 'No email'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().signout(context);
                },
                child: const Text("Sign Out"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
