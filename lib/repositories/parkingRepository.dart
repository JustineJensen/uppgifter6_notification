import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/repository.dart';

class ParkingRepository extends Repository<Parking, int> {
  final String baseUrl = 'http://10.0.2.2:8080/parking';
  int _nextId=1;
  ParkingRepository._internal();
  static final ParkingRepository _instance = ParkingRepository._internal();
  static ParkingRepository get instance => _instance;

  
  @override
  Future<Parking> add(Parking parking) async {
    try {
      print('Sending parking data: ${parking.toJson()}'); 
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJson()),
      );

      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Parking.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add parking (HTTP ${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding parking: $e');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete parking (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error deleting parking: $e');
    }
  }

  @override
  Future<List<Parking>> findAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Parking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch parkings (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching parkings: $e');
    }
  }

  @override
  Future<Parking> findById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return Parking.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Parking not found (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error finding parking: $e');
    }
  }

  @override
  Future<void> update(Parking parking) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${parking.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update parking (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error updating parking: $e');
    }
  }
   Future<int> getNextId() async {
  return _nextId++;
}
}