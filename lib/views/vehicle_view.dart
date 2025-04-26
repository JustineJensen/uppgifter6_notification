import 'package:flutter/material.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';

class VehicleView extends StatelessWidget {
  const VehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Manage Vehicles'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Vehicle'),
              onPressed: () {
                _showAddVehicleDialog(context);
              },
            ),
            const SizedBox(height: 20),
            // Main view for displaying vehicles list
            Expanded(
              child: FutureBuilder<List<Vehicle>>(
                future: VehicleRepository.instance.findAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No vehicles available.'));
                  }

                  final vehicles = snapshot.data!;

                  return ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text('ID: ${vehicle.id}'),
                          subtitle: Text(
                            'Reg Number: ${vehicle.registreringsNummer}\n'
                            'Type: ${vehicle.typ.name}\n'
                            'Owner: ${vehicle.owner.namn}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showUpdateVehicleDialog(context, vehicle),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    await VehicleRepository.instance.deleteById(vehicle.id);
                                    // After deleting, we refresh the list
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const VehicleView()),
                                    );
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

  // Show Add Vehicle Dialog
  void _showAddVehicleDialog(BuildContext context) {
    final regNumController = TextEditingController();
    final colorController = TextEditingController();
    final ownerNameController = TextEditingController();
    final ownerIdController = TextEditingController();
    VehicleType selectedType = VehicleType.Bil;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add New Vehicle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: regNumController,
                  decoration: const InputDecoration(labelText: 'Registration Number'),
                ),
                DropdownButtonFormField<VehicleType>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Vehicle Type'),
                  onChanged: (VehicleType? newValue) {
                    if (newValue != null) {
                      selectedType = newValue;
                    }
                  },
                  items: VehicleType.values.map((type) {
                    return DropdownMenuItem<VehicleType>(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                TextField(
                  controller: ownerNameController,
                  decoration: const InputDecoration(labelText: 'Owner Name'),
                ),
                TextField(
                  controller: ownerIdController,
                  decoration: const InputDecoration(labelText: 'Owner ID'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final regNum = regNumController.text.trim();
                final color = colorController.text.trim();
                final ownerName = ownerNameController.text.trim();
                final personnummer = int.tryParse(ownerIdController.text.trim()) ?? -1;

                if (regNum.isEmpty || color.isEmpty || ownerName.isEmpty || personnummer == -1) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                try {
                  final newVehicle = Car(
                    id: await VehicleRepository.instance.getNextId(),
                    registreringsNummer: regNum,
                    typ: selectedType,
                    owner: Person(namn: ownerName, personNummer: personnummer),
                    color: color,
                  );

                  await VehicleRepository.instance.add(newVehicle);

                  Navigator.pop(dialogContext);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleView()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error adding vehicle: $e')),
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

  // Show Update Vehicle Dialog
  void _showUpdateVehicleDialog(BuildContext context, Vehicle vehicle) {
    final regNumController = TextEditingController(text: vehicle.registreringsNummer);
    final colorController = TextEditingController(text: (vehicle as Car).color);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Update Vehicle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: regNumController,
                decoration: const InputDecoration(labelText: 'Registration Number'),
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final regNum = regNumController.text.trim();
                final color = colorController.text.trim();

                if (regNum.isEmpty || color.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                try {
                  final updatedVehicle = Car(
                    id: vehicle.id,
                    registreringsNummer: regNum,
                    typ: vehicle.typ,
                    owner: vehicle.owner,
                    color: color,
                  );

                  await VehicleRepository.instance.update(vehicle.id, updatedVehicle);

                  Navigator.pop(dialogContext);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleView()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error updating vehicle: $e')),
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

  // Show View All Vehicles Dialog
  void _showVehiclesListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('All Vehicles'),
          content: FutureBuilder<List<Vehicle>>(
            future: VehicleRepository.instance.findAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No vehicles available.');
              }

              final vehicles = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return ListTile(
                    title: Text('Reg Number: ${vehicle.registreringsNummer}'),
                    subtitle: Text('Type: ${vehicle.typ.name}'),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
