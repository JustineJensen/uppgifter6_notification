import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/repositories/file_repository.dart';
import 'package:uppgift3_new_app/repositories/parking_space_repository.dart';

class ParkingRepository extends FileRepository<Parking, int> {
  
  static ParkingRepository _instance = ParkingRepository._internal();
  static ParkingRepository get instance => _instance;
  final CollectionReference _parkingCollection = FirebaseFirestore.instance.collection('parkings');

  FirebaseFirestore? _firestore;
  
  CollectionReference get _collection {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!.collection('parkings');
  }

  ParkingRepository._internal() : super('parking_data.json');

  // Add new parking 
  @override
  Future<Parking> add(Parking parking) async {
    try {
      final allDocs = await _collection.orderBy('id', descending: true).limit(1).get();
      int nextId = 1;
      if (allDocs.docs.isNotEmpty) {
        final data = allDocs.docs.first.data() as Map<String, dynamic>;
        final maxId = data['id'] ?? 0;
        nextId = maxId + 1;
      }

      final newParking = parking.copyWith(id: nextId .toString());
      await _collection.add(newParking.toJson());

      return newParking;
    } catch (e) {
      throw Exception('Error adding parking: $e');
    }
  }

  // Delete parking by ID 
  @override
  Future<void> deleteById(int id) async {
    try {
      final query = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (query.docs.isNotEmpty) {
        await _collection.doc(query.docs.first.id).delete();
      } else {
        throw Exception('Parking with id $id not found');
      }
    } catch (e) {
      throw Exception('Error deleting parking: $e');
    }
  }

    Future<Parking> updateByDocId(String docId, Parking newParking) async {
    try {
      await _collection.doc(docId).update(newParking.toJson()); 
      return newParking;
    } catch (e) {
      throw Exception('Error updating parking: $e');
    }
  }

  Future<void> deleteByDocId(String docId) async {
      try {
        await _collection.doc(docId).delete();
      } catch (e) {
        throw Exception('Error deleting parking: $e');
      }
    }

  // Get all parking 
    @override
    Future<List<Parking>> findAll() async {
      try {
        final snapshot = await _collection.get();
        return snapshot.docs.map((doc) {
          return Parking.fromJson(doc.data() as Map<String, dynamic>, docId: doc.id);
        }).toList();
      } catch (e) {
        throw Exception('Error fetching parkings: $e');
      }
   }


  // Find a specific parking by ID
  @override
  Future<Parking> findById(int id) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (snapshot.docs.isEmpty) {
        throw Exception('Parking not found');
      }

      return Parking.fromJson(snapshot.docs.first.data() as Map<String, dynamic>); 
    } catch (e) {
      throw Exception('Error finding parking: $e');
    }
  }

  // Update parking by ID in Firestore
  @override
  Future<Parking> update(int id, Parking newParking) async {
    try {
      if (newParking.docId == null) {
        throw Exception('Cannot update parking: docId is null');
      }

      await _collection.doc(newParking.docId).update(newParking.toJson());
      return newParking;
    } catch (e) {
      throw Exception('Error updating parking: $e');
    }
  }
  
  Future<void> startParking(Parking parking) async {
    // Add parking to the database
    try {
      await _parkingCollection.add(parking.toJson());
    } catch (e) {
      throw Exception("Failed to start parking: $e");
    }
  }
  Future<void> endParking(String docId) async {
  final parking = await getParkingByDocId(docId);
  if (parking != null) {
    final updated = parking.copyWith(endTime: DateTime.now());
    await update(int.parse(updated.id), updated); 
  }
}


  @override
  Parking fromJson(Map<String, dynamic> json) {
    return Parking.fromJson(json);
  }

  @override
  int idFromType(Parking parking) {
    return int.parse(parking.id);
  }

  @override
  Map<String, dynamic> toJson(Parking parking) {
    return parking.toJson();
  }

  
  getParkingByDocId(String docId) {
    return docId;
  }
  
}
