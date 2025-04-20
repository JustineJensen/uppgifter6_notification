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
  final List<ParkingSpace> ParkingSpaces;

  const ParkingSpaceLoaded(this.ParkingSpaces);

  @override
  List<Object?> get props => [ParkingSpaces];
}

class ParkingSpaceError extends ParkingSpaceState {
  final String message;

  const ParkingSpaceError(this.message);

  @override
  List<Object?> get props => [message];
}
