import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/repository.dart';

class PersonRepository extends Repository<Person, int> {
  final String baseUrl = 'http://10.0.2.2:8080/person';

  PersonRepository._internal();
  static final PersonRepository _instance = PersonRepository._internal();
  static PersonRepository get instance => _instance;

  @override
  Future<Person> add(Person person) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Person.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add person (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error adding person: $e');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete person (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error deleting person: $e');
    }
  }

  @override
  Future<List<Person>> findAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Person.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch persons (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching persons: $e');
    }
  }

  @override
  Future<Person> findById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return Person.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Person not found (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error finding person: $e');
    }
  }

  @override
  Future<void> update(Person person) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${person.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update person (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error updating person: $e');
    }
  }
}