import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/parkingSpace.dart';



abstract class ParkingSpaceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingSpaceInitial extends ParkingSpaceState {}

class ParkingSpaceLoading extends ParkingSpaceState {}

class ParkingSpaceLoaded extends ParkingSpaceState {
  final List<ParkingSpace> parkingSpaces;

  ParkingSpaceLoaded(this.parkingSpaces);

  @override
  List<Object?> get props => [parkingSpaces];
}

class ParkingSpaceError extends ParkingSpaceState {
  final String message;

  ParkingSpaceError(this.message);

  @override
  List<Object?> get props => [message];
}
