import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingRepository _parkingRepository;

  ParkingBloc(this._parkingRepository) : super(ParkingInitial()) {
    on<LoadParkings>(_onLoadParkings);
    on<AddParking>(_onAddParking);
    on<UpdateParking>(_onUpdateParking);
    on<DeleteParking>(_onDeleteParking);
    on<StreamParkings>(_onStreamParkings);

  }

  Future<void> _onLoadParkings(LoadParkings event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());

    await emit.forEach<List<Parking>>(
      _parkingRepository.parkingsStream(), 
      onData: (parkings) => ParkingLoaded(parkings),
      onError: (error, stackTrace) => ParkingError('Failed to load parkings: $error'),
    );
  }

Future<void> _onAddParking(AddParking event, Emitter<ParkingState> emit) async {
    try {
      await _parkingRepository.add(event.parking);
    } catch (e) {
      emit(ParkingError('Failed to add parking: $e'));
    }
  }

  Future<void> _onUpdateParking(UpdateParking event, Emitter<ParkingState> emit) async {
    try {
      await _parkingRepository.update(event.id, event.updatedParking);
    } catch (e) {
      emit(ParkingError('Failed to update parking: $e'));
    }
  }

  Future<void> _onDeleteParking(DeleteParking event, Emitter<ParkingState> emit) async {
    try {
      await _parkingRepository.deleteById(event.id);
    } catch (e) {
      emit(ParkingError('Failed to delete parking: $e'));
    }
  }
  

  Future<void> _onStreamParkings(StreamParkings event, Emitter<ParkingState> emit) async {
  emit(ParkingLoading());

  await emit.forEach<List<Parking>>(
    _parkingRepository.parkingsStream(),
    onData: (parkings) => ParkingLoaded(parkings),
    onError: (error, _) => ParkingError('Stream error: $error'),
  );
}

}
