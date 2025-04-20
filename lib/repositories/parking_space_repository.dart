import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/repositories/file_repository.dart';




class ParkingSpaceRepository extends FileRepository<ParkingSpace,int> {
  int _nextId =0;
  final String baseUrl = 'http://localhost:8082/parkingSpaces';
    ParkingSpaceRepository._internal():super('parkingSpace_data.json');
 

   static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();

   static ParkingSpaceRepository get instance => _instance;
    
      @override
    Future <ParkingSpace> add(ParkingSpace parkingSpace) async {
       try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ParkingSpace.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add parking Space (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error adding parking Space: $e');
    }
   }

   
     @override
    Future <void> deleteById(int id)async {
       try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete parking space (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error deleting parking space: $e');
    }
     }
   
     @override
     Future <List<ParkingSpace>> findAll() async {
      try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ParkingSpace.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch parking space (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching parking spaces: $e');
    }

     }
   
     
    @override
  Future<ParkingSpace> findById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic>) {
          return ParkingSpace.fromJson(jsonData);
        } else {
          throw Exception('Invalid data format received');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Parking space not found');
      } else {
        throw Exception('Failed to fetch parking space (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error finding parking space: $e');
    }
  }
     @override
     Future <ParkingSpace> update(int id,ParkingSpace newParkingSpace) async{
       try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newParkingSpace.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update parking space (HTTP ${response.statusCode})');
      }
      final updatedParkingSpace = ParkingSpace.fromJson(jsonDecode(response.body));
      return updatedParkingSpace;

    } catch (e) {
      throw Exception('Error updating parking space: $e');
    }
  }
  Future<int> getNextId() async {
  return _nextId++;
}

  @override
  ParkingSpace fromJson(Map<String, dynamic> json) {
    return ParkingSpace.fromJson(json);
  }

  @override
  int idFromType(ParkingSpace parkingSpace) {
   return parkingSpace.id;
  }

  @override
  Map<String, dynamic> toJson(ParkingSpace parkingSpace) {
    return parkingSpace.toJson();
  }
  }