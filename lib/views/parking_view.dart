import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_event.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_state.dart';
import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/models/parkingSpace.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/models/vehicleType.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';

class ParkingView extends StatelessWidget {
  const ParkingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingBloc(ParkingRepository.instance)..add(LoadParkings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Parking'),
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ParkingBloc, ParkingState>(
            builder: (context, state) {
              if (state is ParkingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ParkingError) {
                return Center(child: Text(state.message));
              } else if (state is ParkingLoaded) {
                final parkings = state.parkings;
                if (parkings.isEmpty) {
                  return const Center(child: Text('No parking data found.'));
                }
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
                          return _buildParkingCard(context, parking);
                        },
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); 
            },
          ),
        ),
      ),
    );
  }

  Widget _buildParkingCard(BuildContext context, Parking parking) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${parking.fordon.registreringsNummer}'),
            Text('Parking Space: ${parking.parkingSpace.id}'),
            Text('Location: ${parking.parkingSpace.adress}'),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Time: ${_formatDateTime(parking.startTime)}'),
            if (parking.endTime != null)
              Text('End Time: ${_formatDateTime(parking.endTime!)}'),
            Text('Status: ${parking.endTime == null ? 'Active' : 'Completed'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (parking.endTime == null)
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.red),
                onPressed: () => _endParking(context, parking),
              )
            else
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                onPressed: () => _startParking(context, parking),
              ),
            IconButton(
              icon: const Icon(Icons.attach_money),
              onPressed: () => _calculateCost(context, parking),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showUpdateParkingDialog(context, parking),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteParking(context, parking.id),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteParking(BuildContext context, int id) {
    context.read<ParkingBloc>().add(DeleteParking(id));
  }

  void _startParking(BuildContext context, Parking parking) {
  final updated = Parking(
    id: parking.id,
    fordon: parking.fordon,
    parkingSpace: parking.parkingSpace,
    startTime: DateTime.now(),
    endTime: null,
  );
  context.read<ParkingBloc>().add(UpdateParking(parking.id, updated));
}


  void _endParking(BuildContext context, Parking parking) {
  final updated = Parking(
    id: parking.id,
    fordon: parking.fordon,
    parkingSpace: parking.parkingSpace,
    startTime: parking.startTime,
    endTime: DateTime.now(),
  );
  context.read<ParkingBloc>().add(UpdateParking(parking.id, updated));
}

  void _showAddParkingDialog(BuildContext context) {
    final registrationController = TextEditingController();
    final ownerController = TextEditingController();
    final colorController = TextEditingController();
    final parkingSpaceIdController = TextEditingController();
    final parkingLocationController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add New Parking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField(registrationController, 'Registration Number'),
                _textField(ownerController, 'Owner'),
                _textField(colorController, 'Color'),
                _textField(parkingSpaceIdController, 'Parking Space ID', isNumber: true),
                _textField(parkingLocationController, 'Parking Location'),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                final regNum = registrationController.text.trim();
                final owner = ownerController.text.trim();
                final color = colorController.text.trim();
                final spaceId = int.tryParse(parkingSpaceIdController.text.trim());
                final location = parkingLocationController.text.trim();

                if ([regNum, owner, color, location].any((v) => v.isEmpty) || spaceId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                final parking = Parking(
                  id: DateTime.now().millisecondsSinceEpoch,
                  fordon: Car(
                    id: DateTime.now().millisecondsSinceEpoch,
                    registreringsNummer: regNum,
                    typ: VehicleType.Bil,
                    owner: Person(namn: owner, personNummer: -1),
                    color: color,
                  ),
                  parkingSpace: ParkingSpace(id: spaceId, adress: location, pricePerHour: 20.0),
                  startTime: DateTime.now(),
                  endTime: null,
                );

                context.read<ParkingBloc>().add(AddParking(parking));
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateParkingDialog(BuildContext context, Parking parking) {
    final regCtrl = TextEditingController(text: parking.fordon.registreringsNummer);
    final ownerCtrl = TextEditingController(text: parking.fordon.owner.namn);
   final colorCtrl = TextEditingController(
    text: (parking.fordon is Car) ? (parking.fordon as Car).color : '',);

    final spaceIdCtrl = TextEditingController(text: parking.parkingSpace.id.toString());
    final locationCtrl = TextEditingController(text: parking.parkingSpace.adress);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Update Parking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField(regCtrl, 'Registration Number'),
                _textField(ownerCtrl, 'Owner'),
                _textField(colorCtrl, 'Color'),
                _textField(spaceIdCtrl, 'Parking Space ID', isNumber: true),
                _textField(locationCtrl, 'Parking Location'),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final reg = regCtrl.text.trim();
                final own = ownerCtrl.text.trim();
                final col = colorCtrl.text.trim();
                final id = int.tryParse(spaceIdCtrl.text.trim());
                final loc = locationCtrl.text.trim();

                if ([reg, own, col, loc].any((v) => v.isEmpty) || id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

               final updated = Parking(
                id: parking.id,
                fordon: Car(
                  id: parking.fordon.id,
                  registreringsNummer: reg,
                  typ: parking.fordon.typ,
                  owner: Person(
                    namn: own,
                    personNummer: parking.fordon.owner.personNummer,
                  ),
                  color: col,
                ),
                parkingSpace: ParkingSpace(
                  id: id,
                  adress: loc,
                  pricePerHour: parking.parkingSpace.pricePerHour,
                ),
                startTime: parking.startTime,
                endTime: parking.endTime,
              );

                context.read<ParkingBloc>().add(UpdateParking(parking.id, updated));
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _textField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  void _calculateCost(BuildContext context, Parking parking) {
    final endTime = parking.endTime ?? DateTime.now();
    final duration = endTime.difference(parking.startTime);
    final hours = duration.inMinutes / 60;
    final cost = hours * parking.parkingSpace.pricePerHour;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parking Cost'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${parking.fordon.registreringsNummer}'),
            Text('Duration: ${hours.toStringAsFixed(2)} hours'),
            Text('Total Cost: ${cost.toStringAsFixed(2)} kr'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(icon: Icon(icon), label: Text(label), onPressed: onPressed);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

