import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift3_new_app/models/parkingSpace.dart';

class ParkingSpaceView extends StatelessWidget {
  const ParkingSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParkingSpaceBloc, ParkingSpaceState>(
      listener: (context, state) {
        if (state is ParkingSpaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Parking Spaces'),
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
                onPressed: () => _showAddParkingSpaceDialog(context),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<ParkingSpaceBloc>().add(LoadParkingSpaces());
                },
                child: const Text('View All Parking Spaces'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<ParkingSpaceBloc, ParkingSpaceState>(
                  builder: (context, state) {
                    if (state is ParkingSpaceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ParkingSpaceLoaded) {
                      if (state.parkingSpaces.isEmpty) {
                        return const Center(child: Text('No parking spaces available.'));
                      }

                      return ListView.builder(
                        itemCount: state.parkingSpaces.length,
                        itemBuilder: (context, index) {
                          final space = state.parkingSpaces[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text('ID: ${index + 1}'),
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
                                    onPressed: () {
                                      context.read<ParkingSpaceBloc>().add(DeleteParkingSpace(space.id));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ParkingSpaceError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox(); 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddParkingSpaceDialog(BuildContext context) {
    final addressController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
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
              onPressed: () {
                final address = addressController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (address.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                final newSpace = ParkingSpace(
                  id: DateTime.now().millisecondsSinceEpoch,
                  adress: address,
                  pricePerHour: price,
                );

                context.read<ParkingSpaceBloc>().add(AddParkingSpace(newSpace));
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateParkingSpaceDialog(BuildContext context, ParkingSpace space) {
    final addressController = TextEditingController(text: space.adress);
    final priceController = TextEditingController(text: space.pricePerHour.toString());

    showDialog(
      context: context,
      builder: (_) {
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
              onPressed: () {
                final address = addressController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (address.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                final updatedSpace = ParkingSpace(
                  id: space.id,
                  adress: address,
                  pricePerHour: price,
                );

                context.read<ParkingSpaceBloc>().add(
                      UpdateParkingSpace(space.id, updatedSpace),
                    );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
