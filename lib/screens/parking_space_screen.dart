import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/repositories/parking_space_repository.dart';
          
class ParkingSpacecontent extends StatelessWidget {
  const ParkingSpacecontent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingSpaceBloc(repository: ParkingSpaceRepository.instance)..add(LoadParkingSpaces()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Parking Places'),
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOption(context, 'Add New Parking Space', Icons.add_location, () {
                final newSpace = ParkingSpace(
                  id: DateTime.now().millisecondsSinceEpoch,
                  adress: 'New Address',
                  pricePerHour: 10.0,
                );
                context.read<ParkingSpaceBloc>().add(AddParkingSpace(newSpace));
              }),
              _buildOption(context, 'View All Parking Spaces', Icons.map, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewParkingSpacesScreen()),
                );
              }),
              _buildOption(context, 'Update Parking Space', Icons.edit_location, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Select a space to update in 'View All'")),
                );
              }),
              _buildOption(context, 'Delete Parking Space', Icons.delete, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Long-press in 'View All' to delete")),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}

class ViewParkingSpacesScreen extends StatelessWidget {
  const ViewParkingSpacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Parking Spaces')),
      body: BlocBuilder<ParkingSpaceBloc, ParkingSpaceState>(
        builder: (context, state) {
          if (state is ParkingSpaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ParkingSpaceLoaded) {
            final spaces = state.ParkingSpaces;
            return ListView.builder(
              itemCount: spaces.length,
              itemBuilder: (context, index) {
                final space = spaces[index];
                return ListTile(
                  title: Text('Adress: ${space.adress}'),
                  subtitle: Text('Price/hour: ${space.pricePerHour} kr'),
                  onLongPress: () {
                    context.read<ParkingSpaceBloc>().add(DeleteParkingSpace(space.id));
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      final updated = space.copyWith(
                        adress: '${space.adress} (Updated)',
                        pricePerHour: space.pricePerHour + 5.0,
                      );
                      context.read<ParkingSpaceBloc>().add(UpdateParkingSpace(updated));
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Error loading parking spaces or none found.'));
          }
        },
      ),
    );
  }
}
