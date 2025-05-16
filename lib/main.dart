import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uppgift3_new_app/blocs/auth/auth_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_event.dart';
import 'package:uppgift3_new_app/firebase_options.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';
import 'package:uppgift3_new_app/repositories/parkingSpaceRepository.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';
import 'package:uppgift3_new_app/views/home.dart';
import 'package:uppgift3_new_app/views/landingpage.dart';
import 'package:uppgift3_new_app/views/person_view.dart';
import 'package:uppgift3_new_app/views/vehicle_view.dart';
import 'package:uppgift3_new_app/views/parking_view.dart';
import 'package:uppgift3_new_app/views/parking_space_view.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(AuthSubscribe()),
        ),
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc()..add(LoadPersons()),
        ),
        BlocProvider<VehicleBloc>(
          create: (_) => VehicleBloc(VehicleRepository.instance)..add(LoadVehicles()),
        ),
        BlocProvider<ParkingBloc>(
          create: (_) => ParkingBloc(ParkingRepository.instance)..add(LoadParkings()),
        ),
        BlocProvider<ParkingSpaceBloc>(
          create: (_) => ParkingSpaceBloc(ParkingSpaceRepository.instance)..add(LoadParkingSpaces()),
        ),
      ],
      child: MaterialApp(
        title: 'Parking App',
        themeMode: _themeMode,
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue.shade800,
            secondary: Colors.blue.shade600,
            error: Colors.red.shade400,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
            titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            toolbarHeight: 64,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade800,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(),
        home: const AuthGate(),
        routes: {
          '/person': (context) => const PersonView(),
          '/vehicles': (context) => const VehicleView(),
          '/parking': (context) => const ParkingView(),
          '/parkingplaces': (context) => const ParkingSpaceView(),
        },
      ),
    );
  }
}
class FormSpacing extends ThemeExtension<FormSpacing> {
  const FormSpacing({required this.vertical, required this.horizontal});

  final double vertical;
  final double horizontal;

  @override
  ThemeExtension<FormSpacing> copyWith({double? vertical, double? horizontal}) {
    return FormSpacing(
      vertical: vertical ?? this.vertical,
      horizontal: horizontal ?? this.horizontal,
    );
  }

  @override
  ThemeExtension<FormSpacing> lerp(ThemeExtension<FormSpacing>? other, double t) {
    if (other is! FormSpacing) return this;
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthInProgress) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return const Home(title: 'Parking App');
        } else {
          return LandingPage();
        }
      },
    );
  }
}
