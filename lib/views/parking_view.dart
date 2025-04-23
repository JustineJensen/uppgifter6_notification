import 'package:flutter/material.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';


class ParkingView extends StatelessWidget {
  const ParkingView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _showParkingDialog(context);
                }),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: parkings.length,
                    itemBuilder: (context, index) {
                      final parking = parkings[index];
                      return Card(
                        child: ListTile(
                         // title: Text(parking.fordon.registreringsNummer),
                          //subtitle: Text(parking.fordon.owner.namn),
                          trailing: IconButton(
                            icon: const Icon(Icons.attach_money),
                            onPressed: () {
                              _calculateCost(context, parking);
                            },
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

  void _showParkingDialog(BuildContext context) {
    // You can reuse your existing _showParkingDialog logic here
  }

  void _calculateCost(BuildContext context, Parking parking) async {
    final endTime = DateTime.now();
    final duration = endTime.difference(parking.startTime);
    final hours = duration.inMinutes / 60;
    //final cost = hours * parking.parkingSpace.pricePerHour;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parking Ended'),
        //content: Text('Duration: ${hours.toStringAsFixed(2)} hours\nTotal Cost: ${cost.toStringAsFixed(2)} kr'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
