import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';

abstract class ParkingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingInitial extends ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingLoaded extends ParkingState {
  final List<Parking> parkings;

  ParkingLoaded(this.parkings);

  @override
  List<Object?> get props => [parkings];
}

class AvailableParkingSpacesLoaded extends ParkingState {
  final List<ParkingSpace> availableSpaces;

  AvailableParkingSpacesLoaded(this.availableSpaces);

  @override
  List<Object?> get props => [availableSpaces];
}

class ParkingAdded extends ParkingState {
  final Parking parking;

  ParkingAdded(this.parking);

  @override
  List<Object?> get props => [parking];
}

class ParkingUpdated extends ParkingState {
  final Parking updatedParking;

  ParkingUpdated(this.updatedParking);

  @override
  List<Object?> get props => [updatedParking];
}

class ParkingDeleted extends ParkingState {
  final int parkingId;

  ParkingDeleted(this.parkingId);

  @override
  List<Object?> get props => [parkingId];
}

class ParkingOperationFailure extends ParkingState {
  final String error;

  ParkingOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
