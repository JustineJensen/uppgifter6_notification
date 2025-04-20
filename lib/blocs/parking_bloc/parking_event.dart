import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/parking.dart';

abstract class ParkingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadParkings extends ParkingEvent {}

class AddParking extends ParkingEvent {
  final Parking parking;

  AddParking(this.parking);

  @override
  List<Object> get props => [parking];
}

class DeleteParking extends ParkingEvent {
  final int parkingId;

  DeleteParking(this.parkingId);

  @override
  List<Object> get props => [parkingId];
}

class UpdateParking extends ParkingEvent {
  final int parkingId;
  final Parking updatedParking;

  UpdateParking(this.parkingId, this.updatedParking);

  @override
  List<Object> get props => [parkingId, updatedParking];
}



