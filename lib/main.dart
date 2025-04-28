import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';  
import 'package:flutter/material.dart';
import 'package:uppgift3_new_app/firebase_options.dart';
import 'package:uppgift3_new_app/views/home.dart';
import 'package:uppgift3_new_app/views/landingpage.dart';
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
      theme: ThemeData.light().copyWith(
        // Color Scheme
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade800,
          secondary: Colors.blue.shade600,
          surface: Colors.white,
          background: Colors.grey.shade50,
          error: Colors.red.shade400,
        ),
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          toolbarHeight: 64,
        ),
        
        // Card Theme
        cardTheme: CardTheme(
          elevation: 2,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
        
        // Button Themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue.shade800,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade800!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade400!),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade800!, width: 2),
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.blue.shade800,
            fontSize: 18,
          ),
          errorStyle: TextStyle(
            color: Colors.red.shade700,
            fontSize: 14,
          ),
        ),
        
        // Dialog Theme
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          contentTextStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        
        // ListTile Theme
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minVerticalPadding: 8,
          dense: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        
        // Add spacing extension
        extensions: const <ThemeExtension<dynamic>>[
          FormSpacing(
            vertical: 16.0,
            horizontal: 8.0,
          ),
        ],
      ),
      
      darkTheme: ThemeData.dark().copyWith(
        // (Add similar dark theme customizations if needed)
      ),
      
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

class FormSpacing extends ThemeExtension<FormSpacing> {
  const FormSpacing({
    required this.vertical,
    required this.horizontal,
  });

  final double vertical;
  final double horizontal;

  @override
  ThemeExtension<FormSpacing> copyWith({
    double? vertical,
    double? horizontal,
  }) {
    return FormSpacing(
      vertical: vertical ?? this.vertical,
      horizontal: horizontal ?? this.horizontal,
    );
  }

  @override
  ThemeExtension<FormSpacing> lerp(
    ThemeExtension<FormSpacing>? other,
    double t,
  ) {
    if (other is! FormSpacing) {
      return this;
    }
    return FormSpacing(
      vertical: lerpDouble(vertical, other.vertical, t)!,
      horizontal: lerpDouble(horizontal, other.horizontal, t)!,
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
      return LandingPage();
    }
  }
}