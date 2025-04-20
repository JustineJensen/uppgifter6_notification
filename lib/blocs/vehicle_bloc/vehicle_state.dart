import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';

abstract class VehicleState extends Equatable {
  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;

  VehicleLoaded(this.vehicles);

  @override
  List<Object> get props => [vehicles];
}

class VehicleOperationFailure extends VehicleState {
  final String error;

  VehicleOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class VehicleAdded extends VehicleState {
  final Vehicle vehicle;

  VehicleAdded(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class VehicleDeleted extends VehicleState {
  final int vehicleId;

  VehicleDeleted(this.vehicleId);

  @override
  List<Object> get props => [vehicleId];
}

class VehicleUpdated extends VehicleState {
  final Vehicle vehicle;

  VehicleUpdated(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}
