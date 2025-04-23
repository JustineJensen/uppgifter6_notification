import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift1/models/car.dart'; 
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle, int> {
  final String _baseUrl = 'http://10.0.2.2:8080/vehicles';

  VehicleRepository._internal();
  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;

@override
 Future<Vehicle> add(Vehicle vehicle) async {
  try {
    print('Sending POST request to $_baseUrl with data: ${vehicle.toJson()}');
    
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    ).timeout(Duration(seconds: 10)); 

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Car.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create vehicle: ${response.statusCode}. Response body: ${response.body}');
    }
  } catch (e) {
    print('Error in VehicleRepository.add: $e');
    rethrow;
  }
}

  @override
  Future<void> deleteById(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete vehicle: ${response.statusCode}');
    }
  }

  @override
  Future<List<Vehicle>> findAll() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Car.fromJson(json)).toList(); 
    } else {
      throw Exception('Failed to load vehicles: ${response.statusCode}');
    }
  }

  @override
  Future<Vehicle> findById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return Car.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load vehicle: ${response.statusCode}');
    }
  }

  @override
  Future<void> update(Vehicle entity) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${entity.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entity.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update vehicle: ${response.statusCode}');
    }
  }

  @override
  Future<Vehicle> findByRegNum(String regNum) async {
    final response = await http.get(Uri.parse('$_baseUrl?registreringsNummer=$regNum'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Car.fromJson(data.first); 
      } else {
        throw Exception('Vehicle with registration number $regNum not found');
      }
    } else {
      throw Exception('Failed to load vehicle: ${response.statusCode}');
    }
  }

  @override
  Future<Vehicle?> getVehicleByRegNum(String regNum) async {
    try {
      return await findByRegNum(regNum);
    } catch (e) {
      return null;
    }
  }
}