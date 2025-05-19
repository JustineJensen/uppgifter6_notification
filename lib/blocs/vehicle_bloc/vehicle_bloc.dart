import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/models/vehicle.dart';
import 'package:uppgift3_new_app/repositories/vehicleRepository.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;

  VehicleBloc(this.repository) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
    on<FindVehicleById>(_onFindById);
    on<FindVehicleByRegNum>(_onFindByRegNum);
    on<StreamVehicles>(_onStreamVehicles);
  }

  Future<void> _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final vehicles = await repository.findAll();
      emit(VehiclesLoaded(vehicles));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onAddVehicle(AddVehicle event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await repository.add(event.vehicle);
      emit(VehicleOperationSuccess());
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(UpdateVehicle event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await repository.update(event.id, event.updatedVehicle);
      emit(VehicleOperationSuccess());
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await repository.deleteById(event.id);
      emit(VehicleOperationSuccess());
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onFindById(FindVehicleById event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final vehicle = await repository.findById(event.id);
      emit(VehicleLoaded(vehicle));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onFindByRegNum(FindVehicleByRegNum event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final vehicle = await repository.findByRegNum(event.regNum);
      emit(VehicleLoaded(vehicle));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

 Future<void> _onStreamVehicles(StreamVehicles event, Emitter<VehicleState> emit) async {
  emit(VehicleLoading());

  await emit.forEach<List<Vehicle>>(
    repository.streamAllVehicles(),
    onData: (vehicles) => VehiclesLoaded(vehicles),
    onError: (error, stackTrace) => VehicleError('Stream error: $error'),
  );
}

}
