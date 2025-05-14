import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/repositories/fileRepository.dart';

class ParkingRepository extends FileRepository<Parking, int> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _nextId = 1;

  ParkingRepository._internal() : super('parking_data.json');

  static final ParkingRepository _instance = ParkingRepository._internal();
  static ParkingRepository get instance => _instance;

  @override
  Future<Parking> add(Parking parking) async {
    try {
      await _firestore
          .collection('parkings')
          .doc(parking.id.toString())
          .set(parking.toJson());
      return parking;
    } catch (e) {
      throw Exception('Error adding parking: $e');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      await _firestore.collection('parkings').doc(id.toString()).delete();
    } catch (e) {
      throw Exception('Error deleting parking: $e');
    }
  }

  @override
  Future<List<Parking>> findAll() async {
    try {
      final snapshot = await _firestore.collection('parkings').get();
      return snapshot.docs.map((doc) => Parking.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching parkings: $e');
    }
  }

  @override
  Future<Parking> findById(int id) async {
    try {
      final doc = await _firestore.collection('parkings').doc(id.toString()).get();
      if (doc.exists) {
        return Parking.fromJson(doc.data()!);
      } else {
        throw Exception('Parking not found');
      }
    } catch (e) {
      throw Exception('Error finding parking: $e');
    }
  }

  @override
  Future<Parking> update(int id, Parking newParking) async {
    try {
      await _firestore
          .collection('parkings')
          .doc(id.toString())
          .set(newParking.toJson());
      return newParking;
    } catch (e) {
      throw Exception('Error updating parking: $e');
    }
  }
  Stream<List<Parking>> parkingsStream() {
    return FirebaseFirestore.instance
        .collection('parkings')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Parking.fromFirestore(doc.data())).toList());
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
    throw UnimplementedError('Local file system not used with Firestore');
  }
}
