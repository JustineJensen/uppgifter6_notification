import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';
import 'parking_event.dart';
import 'parking_state.dart';


class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingRepository _parkingRepository = ParkingRepository.instance;

  ParkingBloc() : super(ParkingInitial()) {
    on<LoadParkings>(_onLoadParkings);
    on<AddParking>(_onAddParking);
    on<UpdateParking>(_onUpdateParking);
    on<DeleteParking>(_onDeleteParking);
  }

  Future<void> _onLoadParkings(LoadParkings event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());
    try {
      final parkings = await _parkingRepository.findAll();
      emit(ParkingLoaded(parkings));
    } catch (e) {
      emit(ParkingError('Failed to load parkings: $e'));
    }
  }

  Future<void> _onAddParking(AddParking event, Emitter<ParkingState> emit) async {
    try {
      await _parkingRepository.add(event.parking);
      add(LoadParkings()); // Refresh list
    } catch (e) {
      emit(ParkingError('Failed to add parking: $e'));
    }
  }

  Future<void> _onUpdateParking(UpdateParking event, Emitter<ParkingState> emit) async {
    try {
      await _parkingRepository.update(event.id, event.updatedParking);
      add(LoadParkings());
    } catch (e) {
      emit(ParkingError('Failed to update parking: $e'));
    }
  }

  Future<void> _onDeleteParking(DeleteParking event, Emitter<ParkingState> emit) async {
    try {
      await _parkingRepository.deleteById(event.id);
      add(LoadParkings());
    } catch (e) {
      emit(ParkingError('Failed to delete parking: $e'));
    }
  }
}
