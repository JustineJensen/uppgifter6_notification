import 'package:equatable/equatable.dart';
import 'package:uppgift1/models/parking.dart';


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

class ParkingError extends ParkingState {
  final String message;

  ParkingError(this.message);

  @override
  List<Object?> get props => [message];
}
