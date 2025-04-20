
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';

abstract class ParkingSpaceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadParkingSpaces extends ParkingSpaceEvent {}

class AddParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  AddParkingSpace(
    this.parkingSpace,
  );

  @override
  List<Object?> get props => [ParkingSpace];

  AddParkingSpace copyWith({
    ParkingSpace? parkingSpace,
  }) {
    return AddParkingSpace(
      parkingSpace ?? this.parkingSpace,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parkingSpace': parkingSpace.toMap(),
    };
  }

  factory AddParkingSpace.fromMap(Map<String, dynamic> map) {
    return AddParkingSpace(
      ParkingSpace.fromMap(map['parkingSpace'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddParkingSpace.fromJson(String source) => AddParkingSpace.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddParkingSpace(parkingSpace: $parkingSpace)';

  @override
  bool operator ==(covariant AddParkingSpace other) {
    if (identical(this, other)) return true;
  
    return 
      other.parkingSpace == parkingSpace;
  }

  @override
  int get hashCode => parkingSpace.hashCode;
}

class UpdateParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  UpdateParkingSpace(this.parkingSpace);

  @override
  List<Object?> get props => [ParkingSpace];
}

class DeleteParkingSpace extends ParkingSpaceEvent {
  final int id;

  DeleteParkingSpace(this.id);

  @override
  List<Object?> get props => [id];
}
