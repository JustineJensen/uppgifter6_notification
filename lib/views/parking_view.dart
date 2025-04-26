import 'package:flutter/material.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';

class ParkingView extends StatelessWidget {
  const ParkingView({super.key});

  @override
  Widget build(BuildContext context) {
    print("ParkingView is building");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Parking'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Parking>>(
          future: ParkingRepository.instance.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No parking data found.'));
            }

            final parkings = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOption(context, 'Add New Parking', Icons.add, () {
                  _showAddParkingDialog(context);
                }),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: parkings.length,
                    itemBuilder: (context, index) {
                      final parking = parkings[index];
                      return Card(
                        child: ListTile(
                          title: Text(parking.toString()),
                          subtitle: Text('Started at: ${parking.startTime}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_money),
                                onPressed: () => _calculateCost(context, parking),
                              ),
                              IconButton(
                                icon: const Icon(Icons.update),
                                onPressed: () => _showUpdateParkingDialog(context, parking),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await _deleteParking(context, parking);
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  void _showAddParkingDialog(BuildContext context) {
    final registrationController = TextEditingController();
    final ownerController = TextEditingController();
    final colorController = TextEditingController();
    final parkingSpaceIdController = TextEditingController();
    final parkingLocationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Parking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: registrationController,
                  decoration: const InputDecoration(labelText: 'Registration Number'),
                ),
                TextField(
                  controller: ownerController,
                  decoration: const InputDecoration(labelText: 'Owner'),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                TextField(
                  controller: parkingSpaceIdController,
                  decoration: const InputDecoration(labelText: 'Parking Space ID'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: parkingLocationController,
                  decoration: const InputDecoration(labelText: 'Parking Location'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final registrationNumber = registrationController.text.trim();
                final owner = ownerController.text.trim();
                final color = colorController.text.trim();
                final parkingSpaceId = int.tryParse(parkingSpaceIdController.text.trim());
                final parkingLocation = parkingLocationController.text.trim();

                if (registrationNumber.isEmpty || owner.isEmpty || color.isEmpty || parkingSpaceId == null || parkingLocation.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                try {
                  final newParking = Parking(
                    id: await ParkingRepository.instance.getNextId(),
                    fordon: Car(
                      id: DateTime.now().millisecondsSinceEpoch,
                      registreringsNummer: registrationNumber,
                      typ: VehicleType.Bil,
                      owner: Person(namn: owner, personNummer: -1),
                      color: color,
                    ),
                    parkingSpace: ParkingSpace(
                      id: parkingSpaceId,
                      adress: parkingLocation,
                      pricePerHour: 20.0,
                    ),
                    startTime: DateTime.now(),
                    endTime: null,
                  );

                  final addedParking = await ParkingRepository.instance.add(newParking);
                  print('New parking added: $addedParking');

                  Navigator.pop(context);
                  (context as Element).markNeedsBuild();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding parking: $e')),
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

  Future<void> _deleteParking(BuildContext context, Parking parking) async {
    try {
      await ParkingRepository.instance.deleteById(parking.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parking deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _calculateCost(BuildContext context, Parking parking) {
    final endTime = DateTime.now();
    final duration = endTime.difference(parking.startTime);
    final hours = duration.inMinutes / 60;
    final cost = hours * 10;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parking Ended'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start Time: ${parking.startTime.toString()}'),
            const SizedBox(height: 8),
            Text('End Time: $endTime'),
            const SizedBox(height: 8),
            Text('Duration: ${hours.toStringAsFixed(2)} hours'),
            Text('Total Cost: ${cost.toStringAsFixed(2)} kr'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUpdateParkingDialog(BuildContext context, Parking parking) {
  final registrationController = TextEditingController(text: parking.fordon.registreringsNummer);
  final ownerController = TextEditingController(text: parking.fordon.owner.namn);
  final colorController = TextEditingController(text: parking.fordon.color);
  final parkingSpaceIdController = TextEditingController(text: parking.parkingSpace.id.toString());
  final parkingLocationController = TextEditingController(text: parking.parkingSpace.adress);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Parking'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: registrationController,
                decoration: const InputDecoration(labelText: 'Registration Number'),
              ),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(labelText: 'Owner'),
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: parkingSpaceIdController,
                decoration: const InputDecoration(labelText: 'Parking Space ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: parkingLocationController,
                decoration: const InputDecoration(labelText: 'Parking Location'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final registrationNumber = registrationController.text.trim();
              final owner = ownerController.text.trim();
              final color = colorController.text.trim();
              final parkingSpaceId = int.tryParse(parkingSpaceIdController.text.trim());
              final parkingLocation = parkingLocationController.text.trim();

              if (registrationNumber.isEmpty || owner.isEmpty || color.isEmpty || parkingSpaceId == null || parkingLocation.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              try {
                final updatedParking = Parking(
                  id: parking.id, // Use the existing ID for update
                  fordon: Car(
                    id: parking.fordon.id,
                    registreringsNummer: registrationNumber,
                    typ: parking.fordon.typ,
                    owner: Person(namn: owner, personNummer: parking.fordon.owner.personNummer),
                    color: color,
                  ),
                  parkingSpace: ParkingSpace(
                    id: parkingSpaceId,
                    adress: parkingLocation,
                    pricePerHour: parking.parkingSpace.pricePerHour,
                  ),
                  startTime: parking.startTime,
                  endTime: parking.endTime,
                );
                await ParkingRepository.instance.update(parking.id, updatedParking);

                print('Parking updated: $updatedParking');

                Navigator.pop(context);
                (context as Element).markNeedsBuild();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating parking: $e')),
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

}

extension on Vehicle {
  get color => null;
}
