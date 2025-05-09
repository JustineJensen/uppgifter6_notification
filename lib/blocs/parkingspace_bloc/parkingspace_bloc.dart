import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift3_new_app/repositories/parkingSpaceRepository.dart';


class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ParkingSpaceRepository _repository = ParkingSpaceRepository.instance;

  ParkingSpaceBloc() : super(ParkingSpaceInitial()) {
    on<LoadParkingSpaces>(_onLoadParkingSpaces);
    on<AddParkingSpace>(_onAddParkingSpace);
    on<UpdateParkingSpace>(_onUpdateParkingSpace);
    on<DeleteParkingSpace>(_onDeleteParkingSpace);
  }

  Future<void> _onLoadParkingSpaces(
    LoadParkingSpaces event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    emit(ParkingSpaceLoading());
    try {
      final spaces = await _repository.findAll();
      emit(ParkingSpaceLoaded(spaces));
    } catch (e) {
      emit(ParkingSpaceError('Failed to load parking spaces: ${e.toString()}'));
    }
  }

  Future<void> _onAddParkingSpace(
    AddParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    try {
      await _repository.add(event.parkingSpace);
      add(LoadParkingSpaces());
    } catch (e) {
      emit(ParkingSpaceError('Failed to add parking space: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateParkingSpace(
    UpdateParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    try {
      await _repository.update(event.id, event.updatedSpace);
      add(LoadParkingSpaces());
    } catch (e) {
      emit(ParkingSpaceError('Failed to update parking space: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteParkingSpace(
    DeleteParkingSpace event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    try {
      await _repository.deleteById(event.id);
      add(LoadParkingSpaces());
    } catch (e) {
      emit(ParkingSpaceError('Failed to delete parking space: ${e.toString()}'));
    }
  }
}
