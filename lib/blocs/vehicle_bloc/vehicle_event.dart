import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';

abstract class VehicleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVehicles extends VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;

  AddVehicle(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class DeleteVehicle extends VehicleEvent {
  final int vehicleId;

  DeleteVehicle(this.vehicleId);

  @override
  List<Object> get props => [vehicleId];
}

class UpdateVehicle extends VehicleEvent {
  final int vehicleId;
  final Vehicle updatedVehicle;

  UpdateVehicle(this.vehicleId, this.updatedVehicle);

  @override
  List<Object> get props => [vehicleId, updatedVehicle];
}
