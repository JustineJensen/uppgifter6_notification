// lib/blocs/ParkingSpace/ParkingSpace_state.dart
import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';

abstract class ParkingSpaceState extends Equatable {
  const ParkingSpaceState();

  @override
  List<Object?> get props => [];
}

class ParkingSpaceInitial extends ParkingSpaceState {}

class ParkingSpaceLoading extends ParkingSpaceState {}

class ParkingSpaceLoaded extends ParkingSpaceState {
  final List<ParkingSpace> parkingSpaces;

  const ParkingSpaceLoaded(this.parkingSpaces);

  @override
  List<Object?> get props => [parkingSpaces];
}

class ParkingSpaceError extends ParkingSpaceState {
  final String message;

  const ParkingSpaceError(this.message);

  @override
  List<Object?> get props => [message];
}

class AvailableParkingSpacesLoaded extends ParkingSpaceState {
  final List<ParkingSpace> availableSpaces;

  const AvailableParkingSpacesLoaded(this.availableSpaces);

  @override
  List<Object?> get props => [availableSpaces];
}
class ParkingSpaceOperationFailure extends ParkingSpaceState {
  final String error;

  const ParkingSpaceOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
