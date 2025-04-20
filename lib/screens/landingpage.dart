import 'package:flutter/material.dart';
import 'login_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Options tab tapped")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center( 
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Parking App!',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
