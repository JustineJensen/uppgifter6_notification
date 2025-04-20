import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_event.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_event.dart';
import 'package:uppgift3_new_app/firebase_options.dart';
import 'package:uppgift3_new_app/repositories/parking_repository.dart';
import 'package:uppgift3_new_app/repositories/person_repository.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';
import 'package:uppgift3_new_app/screens/home.dart';
import 'package:uppgift3_new_app/screens/landingpage.dart';
import 'package:uppgift3_new_app/screens/login_screen.dart';
import 'package:uppgift3_new_app/screens/parking_space_screen.dart';
import 'package:uppgift3_new_app/screens/person_screen.dart';
import 'package:uppgift3_new_app/screens/vehicle_screen.dart';
import 'package:uppgift3_new_app/screens/parking_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc(repository: PersonRepository.instance)..add(LoadPersons()),
        ),
        BlocProvider<VehicleBloc>(
          create: (_) => VehicleBloc(vehicleRepository: VehicleRepository.instance)..add(LoadVehicles()),
        ),
        BlocProvider<ParkingBloc>(
          create: (_) => ParkingBloc(parkingRepository: ParkingRepository.instance)..add(LoadParkings()),
        ),
      ],
      child: MaterialApp(
        title: 'Parking App',
        themeMode: _themeMode,  
        theme: ThemeData.light(), 
        darkTheme: ThemeData.dark(), 
        home: const LandingPage(),
        routes: {
          '/person': (context) => const PersonScreenContent(),
          '/vehicles': (context) => const VehicleScreenContent(),
          '/parking': (context) => ParkingScreenContent(),
          '/parkingplaces': (context) => const ParkingSpacecontent(),
        },
      ),
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
      return LoginScreen();
    }
  }
}
