import 'dart:convert';
import 'dart:io';

abstract class FileRepository<T, ID> {
  final String _filePath;

  FileRepository(this._filePath);

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T person);
  ID idFromType(T person);

  Future<List<T>> readFile() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      await file.writeAsString('[]');
      return [];
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  Future<void> writeFile(List<T> persons) async {
    final file = File(_filePath);
    final jsonList = persons.map((person) => toJson(person)).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<T> create(T person) async {
    final persons = await readFile();
    persons.add(person);
    await writeFile(persons);
    return person;
  }

  Future<List<T>> getAll() async {
    return await readFile();
  }

  Future<T?> getById(ID id) async {
    final persons = await readFile();
    return persons.firstWhere(
      (person) => idFromType(person) == id,
      orElse: () => throw Exception("Id not found"),
    );
  }

  Future<T> update(ID id, T newPerson) async {
    final persons = await readFile();
    final index = persons.indexWhere((person) => idFromType(person) == id);
    if (index == -1) throw Exception('Person not found');
    persons[index] = newPerson;
    await writeFile(persons);
    return newPerson;
  }

  Future<T> delete(ID id) async {
    final persons = await readFile();
    final index = persons.indexWhere((person) => idFromType(person) == id);
    if (index == -1) throw Exception('Item not found');
    final removed = persons.removeAt(index);
    await writeFile(persons);
    return removed;
  }
}
