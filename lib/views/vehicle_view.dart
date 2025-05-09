import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_event.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_state.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';

class VehicleView extends StatelessWidget {
  const VehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleBloc(VehicleRepository.instance)..add(LoadVehicles()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Vehicles'),
          leading: const BackButton(),
        ),
        body: BlocListener<VehicleBloc, VehicleState>(
          listener: (context, state) {
            if (state is VehicleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            } else if (state is VehicleOperationSuccess) {
              context.read<VehicleBloc>().add(LoadVehicles());
            }
          },
          child: Padding(
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
                Expanded(
                  child: BlocBuilder<VehicleBloc, VehicleState>(
                    builder: (context, state) {
                      if (state is VehicleLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is VehicleError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is VehiclesLoaded) {
                        final vehicles = state.vehicles;
                        if (vehicles.isEmpty) {
                          return const Center(child: Text('No vehicles available.'));
                        }

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
                                      onPressed: () {
                                        context.read<VehicleBloc>().add(DeleteVehicle(vehicle.id));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox(); // Default fallback
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

                final newVehicle = Car(
                  id: await VehicleRepository.instance.getNextId(),
                  registreringsNummer: regNum,
                  typ: selectedType,
                  owner: Person(namn: ownerName, personNummer: personnummer),
                  color: color,
                );

                context.read<VehicleBloc>().add(AddVehicle(newVehicle));
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

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
              onPressed: () {
                final regNum = regNumController.text.trim();
                final color = colorController.text.trim();

                if (regNum.isEmpty || color.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                final updatedVehicle = Car(
                  id: vehicle.id,
                  registreringsNummer: regNum,  
                  typ: vehicle.typ,
                  owner: vehicle.owner,
                  color: color,
                );

                context.read<VehicleBloc>().add(UpdateVehicle(vehicle.id, updatedVehicle));
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
