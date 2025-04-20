import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';
import 'package:uppgift3_new_app/models/vhicletype.dart';

class Car extends Vehicle {
  late String _color;

  // Constructor
  Car({
    required super.id,
    required super.registreringsNummer,
    required super.typ,
    required super.owner,
    required String color,
  })  : _color = color;

  // Getters
  String get color => _color;

  // Setters
  set color(String color) {
    if (color.isNotEmpty) {
      _color = color;
    } else {
      throw Exception("Color cannot be empty.");
    }
  }

  @override
  String toString() {
    return 'Car{id: $id, registreringsnummer: $registreringsNummer, typ: $typ, owner: ${owner.namn}, color: $_color}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registreringsNummer': registreringsNummer,
      'typ': typ.toJson(),
      'owner': owner.toJson(),
      'color': color,
    };
  }
  Car copyWith({
    int? id,
    String? registreringsNummer,
    VehicleType? typ,
    Person? owner,
    String? color,
  }) {
    return Car(
      id: id ?? this.id,
      registreringsNummer: registreringsNummer ?? this.registreringsNummer,
      typ: typ ?? this.typ,
      owner: owner ?? this.owner,
      color: color ?? this.color,
    );
  }
    factory Car.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] ??= int.tryParse(doc.id) ?? DateTime.now().millisecondsSinceEpoch;

    return Car.fromJson(data);
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json');

    if (!json.containsKey('typ') && json.containsKey('vehicleTyp')) {
      json['typ'] = json['vehicleTyp'];
    }

    if (!json.containsKey('registreringsNummer') ||
        !json.containsKey('typ') ||
        !json.containsKey('owner') ||
        !json.containsKey('color')) {
      throw Exception('Missing required fields in JSON: $json');
    }

    var vehicleTypeValue = json['typ'];
    VehicleType vehicleType;
    try {
      vehicleType = VehicleTypeExtension.fromJson(vehicleTypeValue);
    } catch (e) {
      throw Exception('Invalid vehicle type: $vehicleTypeValue');
    }

    Map<String, dynamic>? ownerJson = json['owner'];
    if (ownerJson == null || ownerJson.isEmpty) {
      throw Exception('Owner data is missing or empty in JSON: $json');
    }

    Person owner;
    try {
      owner = Person.fromJson(ownerJson, ownerJson['id'].toString());
    } catch (e) {
      throw Exception('Invalid owner data: $ownerJson');
    }

    String registreringsNummer = json['registreringsNummer'];
    if (registreringsNummer.isEmpty) {
      throw Exception('registreringsNummer cannot be empty.');
    }

    String color = json['color'];
    if (color.isEmpty) {
      throw Exception('Color cannot be empty.');
    }

    int? id = json['id'];
    if (id == null) {
      throw Exception('ID is missing in JSON: $json');
    }

    return Car(
      id: id,
      registreringsNummer: registreringsNummer,
      typ: vehicleType,
      owner: owner,
      color: color,
    );
  }
}