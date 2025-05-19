import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';


abstract class VehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadVehicles extends VehicleEvent {}
class StreamVehicles extends VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class UpdateVehicle extends VehicleEvent {
  final int id;
  final Vehicle updatedVehicle;
  UpdateVehicle(this.id, this.updatedVehicle);

  @override
  List<Object?> get props => [id, updatedVehicle];
}

class DeleteVehicle extends VehicleEvent {
  final int id;
  DeleteVehicle(this.id);

  @override
  List<Object?> get props => [id];
}

class FindVehicleById extends VehicleEvent {
  final int id;
  FindVehicleById(this.id);

  @override
  List<Object?> get props => [id];
}

class FindVehicleByRegNum extends VehicleEvent {
  final String regNum;
  FindVehicleByRegNum(this.regNum);

  @override
  List<Object?> get props => [regNum];
}
