import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_event.dart';
import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/models/vhicletype.dart';
import 'package:uppgift3_new_app/repositories/parking_repository.dart';

class ParkingScreenContent extends StatefulWidget {
  const ParkingScreenContent({super.key});

  @override
  _ParkingScreenContentState createState() => _ParkingScreenContentState();
}

class _ParkingScreenContentState extends State<ParkingScreenContent> {
  List<Parking> parkings = [];

  // Load parkings from the repository
  Future<void> _loadParkings() async {
    final allParkings = await ParkingRepository.instance.findAll();
    setState(() {
      parkings = allParkings;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadParkings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingBloc(parkingRepository: ParkingRepository.instance)..add(LoadParkings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Parking'),
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOption(context, 'Add New Parking', Icons.add, () {
                _showParkingDialog(context);
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showViewAllDialog,
                child: const Text('View All Parkings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showParkingDialog(BuildContext context) {
    final regController = TextEditingController();
    final colorController = TextEditingController();
    final ownerController = TextEditingController();
    final personNummerController = TextEditingController();

    VehicleType selectedType = VehicleType.Bil;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Parking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: regController,
                  decoration: const InputDecoration(labelText: 'Vehicle Registration'),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Vehicle Color'),
                ),
                TextField(
                  controller: ownerController,
                  decoration: const InputDecoration(labelText: 'Owner Name'),
                ),
                TextField(
                  controller: personNummerController,
                  decoration: const InputDecoration(labelText: 'Person Number'),
                  keyboardType: TextInputType.number,
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
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final reg = regController.text.trim();
                final color = colorController.text.trim();
                final ownerName = ownerController.text.trim();
                final personNummer = int.tryParse(personNummerController.text.trim());

                if (reg.isNotEmpty && color.isNotEmpty && ownerName.isNotEmpty && personNummer != null) {
                  final newCar = Car(
                    id: DateTime.now().millisecondsSinceEpoch,
                    registreringsNummer: reg,
                    typ: selectedType,
                    owner: Person(namn: ownerName, personNummer: personNummer),
                    color: color,
                  );

                  final newParking = Parking(
                    id: "",
                    fordon: newCar,
                    parkingSpace: ParkingSpace(id: 0, adress: '', pricePerHour: 20),
                    startTime: DateTime.now(),
                  );

                  try {
                    final addedParking = await ParkingRepository.instance.add(newParking);
                    await _loadParkings();

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Parking added successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add parking: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill out all fields correctly.")),
                  );
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  

 void _showViewAllDialog() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 100, 
              minHeight: 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('All Parkings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: parkings.length > 2 ? 2 : parkings.length, 
                    itemBuilder: (context, index) {
                      final parking = parkings[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                        title: Text(parking.fordon.registreringsNummer, style: const TextStyle(fontSize: 14)),
                        subtitle: Text(parking.fordon.owner.namn, style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.attach_money, size: 16),
                          onPressed: () => _calculateCost(parking),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}




  void _calculateCost(Parking parking) async {
  if (parking.docId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cannot calculate: docId missing')),
    );
    return;
  }

  await ParkingRepository.instance.endParking(parking.docId!);
  await _loadParkings();
  setState(() {});

  final updated = await ParkingRepository.instance.getParkingByDocId(parking.docId!);
  if (updated?.endTime == null) return;

  final duration = updated!.endTime!.difference(updated.startTime);
  final hours = duration.inMinutes / 60;
  final cost = hours * updated.parkingSpace.pricePerHour;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Parking Ended'),
      content: Text('Duration: ${hours.toStringAsFixed(2)} hours\nTotal Cost: ${cost.toStringAsFixed(2)} kr'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


  // Helper method to build the option button
  Widget _buildOption(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }

 void _showEditDialog(Parking parking) {
  final regController = TextEditingController(text: parking.fordon.registreringsNummer);
  final colorController = TextEditingController(text: parking.fordon.color);
  final ownerController = TextEditingController(text: parking.fordon.owner.namn);
  final personNummerController = TextEditingController(text: parking.fordon.owner.personNummer.toString());

  VehicleType selectedType = parking.fordon.typ;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Parking'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: regController,
                decoration: const InputDecoration(labelText: 'Vehicle Registration'),
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Vehicle Color'),
              ),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(labelText: 'Owner Name'),
              ),
              TextField(
                controller: personNummerController,
                decoration: const InputDecoration(labelText: 'Person Number'),
                keyboardType: TextInputType.number,
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
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final reg = regController.text.trim();
              final color = colorController.text.trim();
              final ownerName = ownerController.text.trim();
              final personNummer = int.tryParse(personNummerController.text.trim());

              if (reg.isNotEmpty && color.isNotEmpty && ownerName.isNotEmpty && personNummer != null) {
                final updatedCar = Car(
                  id: parking.fordon.id,
                  registreringsNummer: reg,
                  typ: selectedType,
                  owner: Person(namn: ownerName, personNummer: personNummer),
                  color: color,
                );

                final updatedParking = Parking(
                  id: parking.id,
                  docId: parking.docId,
                  fordon: updatedCar,
                  parkingSpace: parking.parkingSpace,
                  startTime: parking.startTime,
                );

                try {
                  await ParkingRepository.instance.update(int.parse(updatedParking.id), updatedParking);

                  await _loadParkings();
                  setState(() {});

                  Navigator.pop(dialogContext); 
                  Navigator.pop(context);       
                  _showViewAllDialog();        

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Parking updated successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update parking: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill out all fields correctly.")),
                );
              }
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

}
