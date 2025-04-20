import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/repositories/file_repository.dart';
import 'package:uppgift3_new_app/repositories/parking_repository.dart';

class ParkingSpaceRepository extends FileRepository<ParkingSpace, int> {
  FirebaseFirestore? _firestore;

  CollectionReference get _collection {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!.collection('parkingSpaces');
  }

  ParkingSpaceRepository._internal() : super('parkingSpace_data.json');

  static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();
  static ParkingSpaceRepository get instance => _instance;

  Future<ParkingSpace> add(ParkingSpace parkingSpace) async {
    try {
  
      final snapshot = await _collection.orderBy('id', descending: true).limit(1).get();
      int nextId = 1;
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        final maxId = data['id'] ?? 0;
        nextId = maxId + 1;
      }
      final newParkingSpace = parkingSpace.copyWith(id: nextId);
      await _collection.add(newParkingSpace.toJson());  

      return newParkingSpace; 
    } catch (e) {
      print("Error adding parking space: $e");
      throw Exception('Error adding parking space: $e');
    }
  }


  @override
  Future<void> deleteById(int id) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).get();
      if (snapshot.docs.isNotEmpty) {
        await _collection.doc(snapshot.docs.first.id).delete();
      } else {
        throw Exception('Parking space with id $id not found');
      }
    } catch (e) {
      throw Exception('Error deleting parking space: $e');
    }
  }

  @override
  Future<List<ParkingSpace>> findAll() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => ParkingSpace.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching parking spaces: $e');
    }
  }

  @override
  Future<ParkingSpace> findById(int id) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (snapshot.docs.isEmpty) {
        throw Exception('Parking space not found');
      }

      return ParkingSpace.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error finding parking space: $e');
    }
  }

  @override
  Future<ParkingSpace> update(int id, ParkingSpace newParkingSpace) async {
    try {
      final snapshot = await _collection.where('id', isEqualTo: id).limit(1).get();
      if (snapshot.docs.isEmpty) {
        throw Exception('Parking space with id $id not found');
      }

      await _collection.doc(snapshot.docs.first.id).update(newParkingSpace.toJson());
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

 Future<List<ParkingSpace>> getAllParkingSpaces() async {
  final allSpaces = await ParkingSpaceRepository.instance.findAll();
  final allParkings = await ParkingRepository.instance.findAll();

  final occupiedIds = allParkings
      .where((p) => p.endTime == null) 
      .map((p) => p.parkingSpace.id)
      .toSet();

  return allSpaces.where((space) => !occupiedIds.contains(space.id)).toList();
}

}
