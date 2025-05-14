
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';

import 'package:uppgift3_new_app/repositories/fileRepository.dart';

class VehicleRepository extends FileRepository<Vehicle, int> {
 
   int _nextId =0;
  VehicleRepository._internal():super('vehicle_data.json');
  static final VehicleRepository _instance = VehicleRepository._internal();
  static VehicleRepository get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Vehicle> add(Vehicle vehicle) async {
    await FirebaseFirestore.instance
        .collection("vehicles")
        .doc(vehicle.id.toString())
        .set(vehicle.toJson());
    return vehicle;
  }

  @override
    Future<void> deleteById(int id) async {
      await _firestore.collection('vehicles')
      .doc(id.toString()).delete();
    }

    @override
    Future<List<Vehicle>> findAll() async {
      final snapshot = await _firestore
      .collection('vehicles').get();
      return snapshot.docs
      .map((doc) => Car
      .fromJson(doc.data()))
      .toList();
    }

    @override
    Future<Vehicle> findById(int id) async {
      final doc = await _firestore
      .collection('vehicles')
      .doc(id.toString()).get();
      if (doc.exists) {
        return Car
        .fromJson(doc.data()!);
      } else {
        throw Exception('Vehicle with ID $id not found');
      }
    }

    @override
    Future<Vehicle> update(int id, Vehicle newVehicle) async {
      final docRef = _firestore.collection('vehicles').doc(id.toString());

      await docRef.set(newVehicle.toJson());
      final updatedDoc = await docRef.get();
      return Car.fromJson(updatedDoc.data()!);
    }

    @override
    Future<Vehicle> findByRegNum(String regNum) async {
      final snapshot = await _firestore
          .collection('vehicles')
          .where('registreringsNummer', isEqualTo: regNum)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Car.fromJson(snapshot.docs.first.data());
      } else {
        throw Exception('Vehicle with registration number $regNum not found');
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

  Future<int> getNextId() async {
      final snapshot = await _firestore
          .collection('vehicles')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return 1;
      } else {
        return snapshot.docs.first['id'] + 1;
      }
    }
  }