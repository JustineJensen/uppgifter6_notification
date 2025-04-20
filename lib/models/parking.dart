
import 'dart:convert';
import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';

class Parking {
  late int _id;
  late Vehicle _fordon;
  late ParkingSpace _parkingSpace;
  late DateTime _startTime;
  DateTime? _endTime;

  // Constructor
  Parking({
    required int id,
    required Vehicle fordon,
    required ParkingSpace parkingSpace,
    required DateTime startTime,
    DateTime? endTime,
  })  : _id = id,
        _fordon = fordon,
        _parkingSpace = parkingSpace,
        _startTime = startTime,
        _endTime = endTime;

  // Getters
  int get id => _id;
  Vehicle get fordon => _fordon;
  ParkingSpace get parkingSpace => _parkingSpace;
  DateTime get startTime => _startTime;
  DateTime? get endTime => _endTime;

  // Setters
  set id(int id) => _id = id;
  set fordon(Vehicle value) => _fordon = value;
  set parkingSpace(ParkingSpace value) => _parkingSpace = value;
  set startTime(DateTime startTime) => _startTime = startTime;
  set endTime(DateTime? endTime) => _endTime = endTime;

 
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      fordon: Car.fromJson(json['fordon']),  
      parkingSpace: ParkingSpace.fromJson(json['parkingSpace']),  
      startTime: DateTime.parse(json['startTime']),  
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,  
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fordon': _fordon.toJson(),  
      'parkingSpace': _parkingSpace.toJson(), 
      'startTime': _startTime.toIso8601String(),  
      'endTime': _endTime?.toIso8601String(),  
    };
  }

  @override
  String toString() {
    return 'Parking{id: $_id, vehicle: ${_fordon.registreringsNummer}, parkingSpace: ${_parkingSpace.id}, startTime: $_startTime, endTime: $_endTime}';
  }
}
