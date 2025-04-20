import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/person.dart';

class PersonRepository {
  
  static final PersonRepository _instance = PersonRepository._internal();
  
  static PersonRepository get instance => _instance;
  FirebaseFirestore? _firestore;
  
  CollectionReference get _personCollection {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!.collection('persons');
  }

  PersonRepository._internal();

  Future<Person> add(Person person) async {
    try {
      final allDocs = await _personCollection.orderBy('id', descending: true).limit(1).get();
      int nextId = 1;
      if (allDocs.docs.isNotEmpty) {
        final data = allDocs.docs.first.data() as Map<String, dynamic>;
        final maxId = data['id'] ?? 0;

        nextId = maxId + 1;
      }

      final newPerson = person.copyWith(id: nextId.toString());
      await _personCollection.add(newPerson.toJson());

      return newPerson;
    } catch (e) {
      throw Exception('Error adding person: $e');
    }
  }

  Future<void> deleteById(int id) async {
    try {
      final query = await _personCollection.where('id', isEqualTo: id).limit(1).get();
      if (query.docs.isEmpty) throw Exception('Person not found');

      final docId = query.docs.first.id;
      await _personCollection.doc(docId).delete();
    } catch (e) {
      throw Exception('Error deleting person: $e');
    }
  }

  /// Get all persons
  Future<List<Person>> findAll() async {
  try {
    final snapshot = await _personCollection.get();
    return snapshot.docs
        .map((doc) => Person.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    throw Exception('Error fetching persons: $e');
  }
}

  /// Find person by int id
  Future<Person?> findById(int id) async {
    try {
      final query = await _personCollection.where('id', isEqualTo: id).limit(1).get();
      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      return Person.fromJson(doc.data() as Map<String, dynamic>, doc.id);

    } catch (e) {
      throw Exception('Error finding person: $e');
    }
  }

  /// Update person by int id
  Future<Person> update(int id, Person newPerson) async {
    try {
      final query = await _personCollection.where('id', isEqualTo: id).limit(1).get();
      if (query.docs.isEmpty) throw Exception('Person not found');

      final docId = query.docs.first.id;
      await _personCollection.doc(docId).update(newPerson.toJson());

      return newPerson;
    } catch (e) {
      throw Exception('Error updating person: $e');
    }
  }
}
