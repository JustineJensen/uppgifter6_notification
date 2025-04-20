import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository}) : super(VehicleInitial());

  @override
  Stream<VehicleState> mapEventToState(VehicleEvent event) async* {
    if (event is LoadVehicles) {
      yield VehicleLoading();
      try {
        final vehicles = await vehicleRepository.findAll();
        yield VehicleLoaded(vehicles);
      } catch (e) {
        yield VehicleOperationFailure(e.toString());
      }
    } else if (event is AddVehicle) {
      yield VehicleLoading();
      try {
        final vehicle = await vehicleRepository.add(event.vehicle);
        yield VehicleAdded(vehicle);
        add(LoadVehicles());
      } catch (e) {
        yield VehicleOperationFailure(e.toString());
      }
    } else if (event is DeleteVehicle) {
      yield VehicleLoading();
      try {
        await vehicleRepository.deleteById(event.vehicleId);
        yield VehicleDeleted(event.vehicleId);
        add(LoadVehicles());
      } catch (e) {
        yield VehicleOperationFailure(e.toString());
      }
    } else if (event is UpdateVehicle) {
      yield VehicleLoading();
      try {
        final updatedVehicle = await vehicleRepository.update(
          event.vehicleId, event.updatedVehicle);
        yield VehicleUpdated(updatedVehicle);
        add(LoadVehicles());
      } catch (e) {
        yield VehicleOperationFailure(e.toString());
      }
    }
  }
}
