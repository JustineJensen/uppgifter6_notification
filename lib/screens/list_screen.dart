import 'package:flutter/material.dart';

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
        title: const Text('List of Options'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return ListTile(
            leading: Icon(item['icon']),
            title: Text(item['title']),
            onTap: () {
              Navigator.pushNamed(context, item['route']);
            },
          );
        },
      ),
    );
  }
}
