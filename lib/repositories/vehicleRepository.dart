import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';
import 'package:uppgift3_new_app/repositories/file_repository.dart';



class VehicleRepository extends FileRepository<Vehicle, int> {
  final String _baseUrl = 'http://localhost:8082/vehicles';

  VehicleRepository._internal():super('vehicle_data.json');
  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;

@override
 Future<Vehicle> add(Vehicle vehicle) async {
  try {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    ).timeout(Duration(seconds: 10)); 

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Car.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create vehicle: ${response.statusCode}. Response body: ${response.body}');
    }
  } catch (e) {
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

 Future<Vehicle> update(int id, Vehicle newVehicle) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newVehicle.toJson()),
    );

    if (response.statusCode == 200) {
      final vehicles = await readFile();
      final index = vehicles.indexWhere((vehicle) => vehicle.id == id);
      if (index == -1) throw Exception("Vehicle not found");
      vehicles[index] = newVehicle;
      await writeFile(vehicles);

      return Car.fromJson(jsonDecode(response.body));
    } else {
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
  
  @override
  Vehicle fromJson(Map<String, dynamic> json) {
   return Car.fromJson(json);
  }
  
  @override
  int idFromType(Vehicle vehicle) {
    return vehicle.id;
  }
  
  @override
  Map<String, dynamic> toJson(Vehicle vehicle) {
    return vehicle.toJson();
  }
}