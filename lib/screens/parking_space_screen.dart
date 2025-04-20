import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/repositories/parking_space_repository.dart';

class ParkingSpacecontent extends StatefulWidget {
  const ParkingSpacecontent({super.key});

  @override
  State<ParkingSpacecontent> createState() => _ParkingSpacecontentState();
}

class _ParkingSpacecontentState extends State<ParkingSpacecontent> {
  late ParkingSpaceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ParkingSpaceBloc(repository: ParkingSpaceRepository.instance);
    _bloc.add(LoadParkingSpaces());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _showAddDialog() {
    final addressController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
              decoration: const InputDecoration(labelText: 'Price Per Hour'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final address = addressController.text.trim();
              final price = double.tryParse(priceController.text.trim()) ?? 0;
              if (address.isNotEmpty && price > 0) {
                final newSpace = ParkingSpace(id: -1, adress: address, pricePerHour: price);
                _bloc.add(AddParkingSpace(newSpace));
                Navigator.pop(context);
              }
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

  void _showViewAllDialog(List<ParkingSpace> spaces) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'All Parking Spaces',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: spaces.length,
                      itemBuilder: (context, index) {
                        final space = spaces[index];
                        return Card(
                          child: ListTile(
                            title: Text('Address: ${space.adress}'),
                            subtitle: Text('Price/hour: ${space.pricePerHour.toStringAsFixed(2)} kr'),
                            trailing: Wrap(
                              spacing: 12,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showEditDialog(space);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _bloc.add(DeleteParkingSpace(space.id));
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(ParkingSpace space) {
    final addressController = TextEditingController(text: space.adress);
    final priceController = TextEditingController(text: space.pricePerHour.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Parking Space'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price Per Hour'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updated = space.copyWith(
                adress: addressController.text.trim(),
                pricePerHour: double.tryParse(priceController.text.trim()) ?? space.pricePerHour,
              );
              _bloc.add(UpdateParkingSpace(updated));
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

  Widget _buildOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Parking Spaces')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ParkingSpaceBloc, ParkingSpaceState>(
            builder: (context, state) {
              List<ParkingSpace> currentSpaces = [];

              if (state is ParkingSpaceLoaded) {
                currentSpaces = state.parkingSpaces;
              }

              return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _buildOption('Add New Parking Space', Icons.add_location, _showAddDialog),
    _buildOption('View All Parking Spaces', Icons.map, () {
      if (currentSpaces.isNotEmpty) {
        _showViewAllDialog(currentSpaces);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No spaces available.')),
        );
      }
    }),
    _buildOption('Show Available Parking Spaces', Icons.local_parking, () {
      _bloc.add(LoadAvailableParkingSpaces());
    }),
    const SizedBox(height: 10),
    if (state is ParkingSpaceLoading)
      const Center(child: CircularProgressIndicator()),

    // Show Available Parking Spaces
    if (state is AvailableParkingSpacesLoaded)
      Expanded(
        child: ListView.builder(
          itemCount: state.availableSpaces.length,
          itemBuilder: (context, index) {
            final space = state.availableSpaces[index];
            return Card(
              child: ListTile(
                title: Text('Address: ${space.adress}'),
                subtitle: Text('Price/hour: ${space.pricePerHour} kr'),
              ),
            );
          },
        ),
      ),

 
    if (state is! AvailableParkingSpacesLoaded &&
        state is! ParkingSpaceLoading)
      const SizedBox(),
  ],
);

            },
          ),
        ),
      ),
    );
  }
}
