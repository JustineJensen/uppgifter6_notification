import 'package:flutter/material.dart';

class ParkingScreenContent extends StatefulWidget {
  const ParkingScreenContent({super.key});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreenContent> {
  List<String> parkings = ['John', 'Jane', 'Alice'];

  void _showParkingDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Parking'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Parking Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  parkings.add(name);
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showViewAllDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: parkings.length,
        itemBuilder: (context, index) {
          final parking = parkings[index];
          return ListTile(
            title: Text(parking),
            onTap: () {
              _showEditDialog(parking);
            },
            onLongPress: () {
              setState(() {
                parkings.removeAt(index);
              });
              Navigator.pop(context);
            },
            trailing: IconButton(
              icon: const Icon(Icons.attach_money),
              onPressed: () => _calculateCost(parking),
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(String current) {
    final controller = TextEditingController(text: current);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Parking'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                setState(() {
                  final index = parkings.indexOf(current);
                  if (index != -1) {
                    parkings[index] = newName;
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _calculateCost(String parking) {
    final cost = parking.length * 10;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parking Cost'),
        content: Text('Cost for "$parking" is \$${cost.toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

 Widget _buildOption(String title, IconData icon, VoidCallback onTap) {
  return Builder(
    builder: (BuildContext context) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: onTap,
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Parkings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOption('Add New Parking', Icons.local_parking, () => _showParkingDialog(context)),
            _buildOption('View All Parkings', Icons.list, _showViewAllDialog),
            _buildOption('Update Parking', Icons.edit, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tap a parking in 'View All' to update.")),
              );
            }),
            _buildOption('Delete Parking', Icons.delete, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Long-press a parking in 'View All' to delete.")),
              );
            }),
          ],
        ),
      ),
    );
  }
}
