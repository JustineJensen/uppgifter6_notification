import 'package:flutter/material.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift3_new_app/repositories/parkingSpaceRepository.dart';


class ParkingSpaceView extends StatelessWidget {
  const ParkingSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Manage Parking Spaces'),
        leading: const BackButton(),
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add New Parking Space'),
        onPressed: () {
          _showAddParkingSpaceDialog(context);
        },
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: _viewAllParkingSpaces,
        child: const Text('View All Parking Spaces'),
      ),
      const SizedBox(height: 20),
      Expanded(
        child: FutureBuilder<List<ParkingSpace>>(
          future: ParkingSpaceRepository.instance.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No parking spaces available.'));
            }

            final parkingSpaces = snapshot.data!;

            return ListView.builder(
              itemCount: parkingSpaces.length,
              itemBuilder: (context, index) {
                final space = parkingSpaces[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('ID: ${space.id}'),
                    subtitle: Text('Address: ${space.adress}\nPrice per hour: ${space.pricePerHour} kr'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showUpdateParkingSpaceDialog(context, space),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await ParkingSpaceRepository.instance.deleteById(space.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Parking space deleted')),
                              );
                              (context as Element).markNeedsBuild();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  ),
),

    );
  }

  // Show Add Parking Space Dialog
  void _showAddParkingSpaceDialog(BuildContext context) {
    final addressController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Parking Space'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price per Hour'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final address = addressController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (address.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                try {
                  final newParkingSpace = ParkingSpace(
                    id: await ParkingSpaceRepository.instance.getNextId(),
                    adress: address,
                    pricePerHour: price,
                  );

                  await ParkingSpaceRepository.instance.add(newParkingSpace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Parking space added successfully')),
                  );

                  Navigator.pop(context);
                  (context as Element).markNeedsBuild();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding parking space: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show Update Parking Space Dialog
  void _showUpdateParkingSpaceDialog(BuildContext context, ParkingSpace space) {
    final addressController = TextEditingController(text: space.adress);
    final priceController = TextEditingController(text: space.pricePerHour.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Parking Space'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price per Hour'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final address = addressController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (address.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                try {
                  final updatedParkingSpace = ParkingSpace(
                    id: space.id,
                    adress: address,
                    pricePerHour: price,
                  );

                  await ParkingSpaceRepository.instance.update(space.id, updatedParkingSpace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Parking space updated successfully')),
                  );

                  Navigator.pop(context);
                  (context as Element).markNeedsBuild();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating parking space: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _viewAllParkingSpaces() {
  }
}
