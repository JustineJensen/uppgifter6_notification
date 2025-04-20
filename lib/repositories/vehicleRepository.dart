import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';
import 'package:uppgift3_new_app/repositories/file_repository.dart';

class VehicleRepository extends FileRepository<Vehicle, int> {

  FirebaseFirestore? _firestore;

  CollectionReference get _collection {
  
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!.collection('vehicles');
  }

  VehicleRepository._internal() : super('vehicle_data.json');

  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;

  @override
  Future<Vehicle> add(Vehicle vehicle) async {
    try {
      final snapshot = await _collection.orderBy('id', descending: true).limit(1).get();
      int nextId = 1;
      if (snapshot.docs.isNotEmpty) {
        final maxId = (snapshot.docs.first.data() as Map<String, dynamic>)['id'] ?? 0;
        nextId = maxId + 1;
      }

      final newVehicle = (vehicle as Car).copyWith(id: nextId);
      await _collection.add(newVehicle.toJson());

      return newVehicle;
    } catch (e) {
      throw Exception('Error adding vehicle: $e');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        await _collection.doc(snapshot.docs.first.id).delete();
      } else {
        throw Exception('Vehicle with id $id not found');
      }
    } catch (e) {
      throw Exception('Error deleting vehicle: $e');
    }
  }

  @override
  Future<List<Vehicle>> findAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => Car.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching vehicles: $e');
    }
  }

  @override
  Future<Vehicle> findById(int id) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (snapshot.docs.isEmpty) throw Exception('Vehicle not found');
      return Car.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error finding vehicle: $e');
    }
  }

  @override
  Future<Vehicle> update(int id, Vehicle newVehicle) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (snapshot.docs.isEmpty) throw Exception('Vehicle not found');

      await _collection.doc(snapshot.docs.first.id).update(newVehicle.toJson());
      return newVehicle;
    } catch (e) {
      throw Exception('Error updating vehicle: $e');
    }
  }

  @override
  Future<Vehicle> findByRegNum(String regNum) async {
    try {
      final snapshot = await _collection
          .where('registreringsNummer', isEqualTo: regNum)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Vehicle with registration number $regNum not found');
      }

      return Car.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error finding vehicle by reg number: $e');
    }
  }

  @override
  Future<Vehicle?> getVehicleByRegNum(String regNum) async {
    try {
      return await findByRegNum(regNum);
    } catch (_) {
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
