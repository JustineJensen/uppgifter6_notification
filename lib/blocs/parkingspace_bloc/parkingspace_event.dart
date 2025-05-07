import 'package:equatable/equatable.dart';
import 'package:uppgift1/models/parkingSpace.dart';


abstract class ParkingSpaceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadParkingSpaces extends ParkingSpaceEvent {}

class AddParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  AddParkingSpace(this.parkingSpace);

  @override
  List<Object?> get props => [parkingSpace];
}

class UpdateParkingSpace extends ParkingSpaceEvent {
  final int id;
  final ParkingSpace updatedSpace;

  UpdateParkingSpace(this.id, this.updatedSpace);

  @override
  List<Object?> get props => [id, updatedSpace];
}

class DeleteParkingSpace extends ParkingSpaceEvent {
  final int id;

  DeleteParkingSpace(this.id);

  @override
  List<Object?> get props => [id];
}
