

import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/models/vehicleType.dart';

abstract class Vehicle {
  late int _id;
  late String _registreringsNummer;
  late VehicleType _typ;
  late Person _owner;

  // Constructor
  Vehicle({
    required int id,
    required String registreringsNummer,
    required VehicleType typ,
    required Person owner,
  })  : _id = id,
        _registreringsNummer = registreringsNummer,
        _typ = typ,
        _owner = owner;

  // Getters
  int get id => _id;
  String get registreringsNummer => _registreringsNummer;
  VehicleType get typ => _typ;
  Person get owner => _owner;

  // Setters
  set id(int id) => _id = id;
  set registreringsNummer(String registreringsNummer) =>
      _registreringsNummer = registreringsNummer;
  set typ(VehicleType typ) => _typ = typ;
  set owner(Person owner) => _owner = owner;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'registreringsNummer': _registreringsNummer,
      'typ': _typ.toJson(), 
      'owner': _owner.toJson(), 
    };
  }

  @override
  String toString() {
    return 'Vehicle{id:$_id, registreringsnummer: $registreringsNummer, typ: $typ, owner: ${owner.namn}}';
  }
}