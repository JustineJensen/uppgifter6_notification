import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';




class VehicleView extends StatefulWidget {
  const VehicleView({super.key});
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  
}
/*
class _VehicleScreenState extends State<VehicleView> {
  List<Car> vehicles = [];

  Future<void> _fetchVehicles() async {
    try {
      QuerySnapshot snapshot = await vehicleRepository.add();
      print('Fetched documents: ${snapshot.docs.length}');

      setState(() {
        vehicles = snapshot.docs.map((doc) {
          print('Document data: ${doc.data()}');
          return Car.fromJson(json);
        }).toList();
      });
    } catch (e) {
      print('Error fetching vehicles: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  void _showVehicleDialog(BuildContext context, {Car? vehicle}) {
    final regNrController = TextEditingController(text: vehicle?.registreringsNummer ?? '');
    final colorController = TextEditingController(text: vehicle?.color ?? '');
    final ownerNameController = TextEditingController(text: vehicle?.owner.namn ?? '');
    final personNummerController = TextEditingController(text: vehicle?.owner.personNummer.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vehicle == null ? 'Add New Vehicle' : 'Update Vehicle'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: regNrController,
                decoration: const InputDecoration(labelText: 'Registreringsnummer'),
              ),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: ownerNameController,
                decoration: const InputDecoration(labelText: 'Owner\'s name'),
              ),
              TextField(
                controller: personNummerController,
                decoration: const InputDecoration(labelText: 'Person Number (12 numbers)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final regNr = regNrController.text.trim();
              final color = colorController.text.trim();
              final ownerName = ownerNameController.text.trim();
              final personNummer = int.tryParse(personNummerController.text.trim());

              if (regNr.isEmpty || color.isEmpty || ownerName.isEmpty || personNummer == null || personNummer.toString().length != 12) {
                print('Invalid input');
                return;
              }

              final car = Car(
                id: DateTime.now().millisecondsSinceEpoch,
                registreringsNummer: regNr,
                typ: VehicleType.car,
                color: color,
                owner: Person(
                  namn: ownerName,
                  personNummer: personNummer,
                ),
              );

              if (vehicle == null) {
                await vehiclesCollection.add(car.toJson());
              } else {
                await vehiclesCollection.doc(vehicle.id.toString()).update(car.toJson());
              }

              Navigator.of(context).pop();
              _fetchVehicles();
            },
            child: Text(vehicle == null ? 'Add' : 'Update'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteVehicle(String vehicleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: const Text('Do you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () async {
              await vehiclesCollection.doc(vehicleId).delete();
              setState(() {
                vehicles.removeWhere((v) => v.id.toString() == vehicleId);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Vehicles'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add and View All buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _showVehicleDialog(context),
                  child: const Text('Add New Vehicle'),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () => _fetchVehicles(),
                  child: const Text('View All Vehicles'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Vehicle List
            Expanded(
              child: vehicles.isEmpty
                  ? const Center(child: Text('No Vehicles available.'))
                  : ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final car = vehicles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.directions_car),
                            title: Text(car.registreringsNummer),
                            subtitle: Text('${car.owner.namn} - ${car.color}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showVehicleDialog(context, vehicle: car),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteVehicle(car.id.toString()),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}*/
