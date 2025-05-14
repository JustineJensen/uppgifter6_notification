import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';


abstract class VehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehiclesLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  VehiclesLoaded(this.vehicles);

  @override
  List<Object?> get props => [vehicles];
}

class VehicleLoaded extends VehicleState {
  final Vehicle vehicle;
  VehicleLoaded(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehicleOperationSuccess extends VehicleState {}

class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}
