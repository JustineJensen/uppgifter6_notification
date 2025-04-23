import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'title': 'Persons',
        'icon': Icons.person,
        'route': '/person',
      },
      {
        'title': 'Vehicles',
        'icon': Icons.directions_car,
        'route': '/vehicles',
      },
      {
        'title': 'Parkings',
        'icon': Icons.history,
        'route': '/parking',
      },
      {
        'title': 'Parking Places',
        'icon': Icons.local_parking,
        'route': '/parkingplaces',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: options.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: ElevatedButton.icon(
                icon: Icon(item['icon']),
                label: Text(item['title']),
                onPressed: () {
                  Navigator.pushNamed(context, item['route']);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50), 
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
