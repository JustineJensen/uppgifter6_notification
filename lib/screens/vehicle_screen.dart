import 'package:flutter/material.dart';

class VehicleScreenContent extends StatefulWidget {
  const VehicleScreenContent({super.key});

  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreenContent> {
  List<String> vehicles = ['Car', 'Bike', 'Truck'];

  void _showVehicleDialog(BuildContext context, {String? vehicle}) {
    TextEditingController vehicleController = TextEditingController(
      text: vehicle ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(vehicle == null ? 'Registrera nytt fordon' : 'Uppdatera fordon'),
          content: TextField(
            controller: vehicleController,
            decoration: const InputDecoration(labelText: 'Fordonstyp'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final input = vehicleController.text.trim();
                if (input.isEmpty) return;

                setState(() {
                  if (vehicle == null) {
                    // Create
                    vehicles.add(input);
                  } else {
                    // Update
                    final index = vehicles.indexOf(vehicle);
                    if (index != -1) {
                      vehicles[index] = input;
                    }
                  }
                });

                Navigator.of(context).pop();
              },
              child: Text(vehicle == null ? 'Lägg till' : 'Uppdatera'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Avbryt'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVehicle(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ta bort fordon'),
        content: Text('Vill du ta bort "${vehicles[index]}"?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                vehicles.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Ja'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Nej'),
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
      appBar: AppBar(
        title: const Text('Hantera Fordon'),
        backgroundColor: Colors.blue,
      ),
      body: vehicles.isEmpty
          ? const Center(child: Text('Inga fordon tillagda ännu.'))
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(vehicles[index]),
                  onTap: () => _showVehicleDialog(context, vehicle: vehicles[index]), // Update
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteVehicle(index), 
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showVehicleDialog(context), 
        child: const Icon(Icons.add),
        tooltip: 'Registrera nytt fordon',
      ),
    );
  }
}
