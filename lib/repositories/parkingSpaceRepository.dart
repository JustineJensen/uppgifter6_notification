import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/parkingSpace.dart';
import 'package:uppgift3_new_app/repositories/fileRepository.dart';

class ParkingSpaceRepository extends FileRepository<ParkingSpace, int> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _nextId = 0;

  ParkingSpaceRepository._internal() : super('parkingSpace_data.json');

  static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();
  static ParkingSpaceRepository get instance => _instance;

  @override
  Future<ParkingSpace> add(ParkingSpace parkingSpace) async {
    try {
      await _firestore.collection('parkingSpaces')
          .doc(parkingSpace.id.toString())
          .set(parkingSpace.toJson());

      return parkingSpace;
    } catch (e) {
      throw Exception('Error adding parking space: $e');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      await _firestore.collection('parkingSpaces').doc(id.toString()).delete();
    } catch (e) {
      throw Exception('Error deleting parking space: $e');
    }
  }

  @override
  Future<List<ParkingSpace>> findAll() async {
    try {
      final snapshot = await _firestore.collection('parkingSpaces').get();
      return snapshot.docs
          .map((doc) => ParkingSpace.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching parking spaces: $e');
    }
  }

  @override
  Future<ParkingSpace> findById(int id) async {
    try {
      final doc = await _firestore.collection('parkingSpaces').doc(id.toString()).get();
      if (doc.exists) {
        return ParkingSpace.fromJson(doc.data()!);
      } else {
        throw Exception('Parking space not found');
      }
    } catch (e) {
      throw Exception('Error finding parking space: $e');
    }
  }

  @override
  Future<ParkingSpace> update(int id, ParkingSpace newParkingSpace) async {
    try {
      await _firestore
          .collection('parkingSpaces')
          .doc(id.toString())
          .set(newParkingSpace.toJson());
      return newParkingSpace;
    } catch (e) {
      throw Exception('Error updating parking space: $e');
    }
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


  Future<File> _getLocalFile(String filename) async {
    throw UnimplementedError('Local file system not used with Firestore');
  }
  Future<int> getNextId() async {
    try {
      final counterDoc = await _firestore.collection('counters').doc('parkingSpacesCounter').get();
      int nextId = 1;

      if (counterDoc.exists) {
        nextId = counterDoc.data()!['nextId'];
        await _firestore.collection('counters').doc('parkingSpacesCounter').update({
          'nextId': nextId + 1,
        });
      } else {
        await _firestore.collection('counters').doc('parkingSpacesCounter').set({
          'nextId': 2, 
        });
      }
      return nextId;
    } catch (e) {
      throw Exception('Error generating next ID: $e');
    }
  }
  Stream<List<ParkingSpace>> parkingSpacesStream() {
  return _firestore
      .collection('parkingSpaces')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ParkingSpace.fromJson(doc.data()))
          .toList());
}

}
