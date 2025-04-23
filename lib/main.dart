import 'package:firebase_auth/firebase_auth.dart';  
import 'package:flutter/material.dart';
import 'package:uppgift3_new_app/firebase_options.dart';
import 'package:uppgift3_new_app/views/home.dart';
import 'package:uppgift3_new_app/views/landingpage.dart';
import 'package:uppgift3_new_app/views/login_view.dart';
import 'package:uppgift3_new_app/views/person_view.dart';
import 'package:uppgift3_new_app/views/vehicle_view.dart';  
import 'package:uppgift3_new_app/views/parking_view.dart'; 
import 'package:uppgift3_new_app/views/parking_space_view.dart'; 
import 'package:firebase_core/firebase_core.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print('Firebase init failed: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const AuthGate(),  
      routes: {
        '/person': (context) => const PersonView(),
        '/vehicles': (context) => const VehicleView(),
        '/parking': (context) => const ParkingView(),
        '/parkingplaces': (context) => const ParkingSpaceView(),
      },
    );
  }
}


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return const Home(title: 'Parking App');
    } else {
      return  LandingPage();
    }
  }
}
