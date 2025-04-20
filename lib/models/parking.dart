import 'package:uppgift3_new_app/models/car.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';

class Parking {
  final String id;
  final String? docId;
  final Car fordon;
  final ParkingSpace parkingSpace;
  final DateTime startTime;
  final DateTime? endTime; 

  Parking({
    required this.id,
    this.docId,
    required this.fordon,
    required this.parkingSpace,
    required this.startTime,
    this.endTime,
  });

  Parking copyWith({
    String? id,
    String? docId,
    Car? fordon,
    ParkingSpace? parkingSpace,
    DateTime? startTime,
    DateTime? endTime, 
  }) {
    return Parking(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      fordon: fordon ?? this.fordon,
      parkingSpace: parkingSpace ?? this.parkingSpace,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime, 
    );
  }

  factory Parking.fromJson(Map<String, dynamic> json, {String? docId}) {
  return Parking(
    id: json['id'],
    docId: docId, 
    fordon: Car.fromJson(json['fordon']),
    parkingSpace: ParkingSpace.fromJson(json['parkingSpace']),
    startTime: DateTime.parse(json['startTime']),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
  );
}


Map<String, dynamic> toJson() => {
  'id': id,
  'docId': docId,
  'fordon': fordon.toJson(),
  'parkingSpace': parkingSpace.toJson(),
  'startTime': startTime.toIso8601String(),
  'endTime': endTime?.toIso8601String(),
};

}
