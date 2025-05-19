import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/repositories/fileRepository.dart';

class PersonRepository extends FileRepository<Person, int> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PersonRepository._internal() : super('person_data.json');

  static PersonRepository _instance = PersonRepository._internal();
  static PersonRepository get instance => _instance;
  static set instance(PersonRepository repo) => _instance = repo;

  @override
  Future<Person> add(Person person) async {
    try {
      await _firestore
          .collection('persons')
          .doc(person.id.toString())
          .set(person.toJson());
      return person;
    } catch (e) {
      throw Exception('Error adding person: $e');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      await _firestore.collection('persons').doc(id.toString()).delete();
    } catch (e) {
      throw Exception('Error deleting person: $e');
    }
  }

  @override
  Future<List<Person>> findAll() async {
    try {
      final snapshot = await _firestore.collection('persons').get();
      return snapshot.docs
          .map((doc) => Person.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching persons: $e');
    }
  }

  @override
  Future<Person?> findById(int id) async {
    try {
      final doc =
          await _firestore.collection('persons').doc(id.toString()).get();
      if (doc.exists) {
        return Person.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error finding person: $e');
    }
  }

  @override
  Future<Person> update(int id, Person newPerson) async {
    try {
      await _firestore
          .collection('persons')
          .doc(id.toString())
          .set(newPerson.toJson());
      return newPerson;
    } catch (e) {
      throw Exception('Error updating person: $e');
    }
  }
    Stream<List<Person>> streamAllPersons() {
    return _firestore.collection('persons').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Person.fromJson(doc.data()))
          .toList();
    });
  }


  @override
  Person fromJson(Map<String, dynamic> json) {
    return Person.fromJson(json);
  }

  @override
  int idFromType(Person person) {
    return person.id;
  }

  @override
  Map<String, dynamic> toJson(Person person) {
    return person.toJson();
  }


  Future<File> _getLocalFile(String filename) async {
    throw UnimplementedError('Local file system not used with Firestore');
  }
}
