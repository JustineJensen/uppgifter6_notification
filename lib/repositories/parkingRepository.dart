import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uppgift1/models/parking.dart';

import 'package:path_provider/path_provider.dart';
import 'package:uppgift3_new_app/repositories/fileRepository.dart';

class ParkingRepository extends FileRepository<Parking, int> {
  final String baseUrl = 'http://10.0.2.2:8082/parking';
  int _nextId=1;
  ParkingRepository._internal() : super('parking_data.json');
  static final ParkingRepository _instance = ParkingRepository._internal();
  static ParkingRepository get instance => _instance;

  
  @override
  Future<Parking> add(Parking parking) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJson()),
      );
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
  Future<Parking> update(int id, Parking newParking) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newParking.toJson()), 
      );

      if (response.statusCode == 200) {
        return newParking;  
      } else {
        throw Exception('Failed to update parking (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error updating parking: $e');
    }
  }

  @override
  Parking fromJson(Map<String, dynamic> json) {
    return Parking.fromJson(json);
  }

  @override
  int idFromType(Parking parking) {
    return parking.id;
  }

  @override
  Map<String, dynamic> toJson(Parking parking) {
   return parking.toJson();
  }
  Future<int> getNextId() async {
  return _nextId++;
}
 Future<File> _getLocalFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$filename');
}

}