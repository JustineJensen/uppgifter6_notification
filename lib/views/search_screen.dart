import 'package:flutter/material.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift3_new_app/repositories/parkingSpaceRepository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ParkingSpace> _allParkingSpaces = [];
  List<ParkingSpace> _filteredParkingSpaces = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadParkingSpaces();
    _searchController.addListener(_filterParkingSpaces);
  }

  void _loadParkingSpaces() async {
    final spaces = await ParkingSpaceRepository.instance.findAll();
    setState(() {
      _allParkingSpaces = spaces;
      _filteredParkingSpaces = spaces;
    });
  }

  void _filterParkingSpaces() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredParkingSpaces = _allParkingSpaces.where((space) {
        return space.adress.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Parking Spaces'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by address...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredParkingSpaces.isEmpty
                  ? const Center(child: Text('No matching parking spaces.'))
                  : ListView.builder(
                      itemCount: _filteredParkingSpaces.length,
                      itemBuilder: (context, index) {
                        final space = _filteredParkingSpaces[index];
                        return Card(
                          child: ListTile(
                            title: Text('ID: ${space.id}'),
                            subtitle: Text('Address: ${space.adress}\nPrice per hour: ${space.pricePerHour} kr'),
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
}
