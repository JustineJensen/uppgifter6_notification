
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift3_new_app/models/parking_space.dart';
import 'package:uppgift3_new_app/repositories/parking_space_repository.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ParkingSpaceRepository repository;

  ParkingSpaceBloc({required this.repository}) : super(ParkingSpaceInitial()) {
    on<LoadParkingSpaces>((event, emit) async {
      emit(ParkingSpaceLoading());
      try {
        final ParkingSpaces = await repository.findAll();
        emit(ParkingSpaceLoaded(ParkingSpaces));
      } catch (e) {
        emit(ParkingSpaceError('Failed to load ParkingSpaces: $e'));
      }
    });

    on<AddParkingSpace>((event, emit) async {
      if (state is ParkingSpaceLoaded) {
        try {
          final created = await repository.add(event.parkingSpace);
          final updatedList = List<ParkingSpace>.from((state as ParkingSpaceLoaded).ParkingSpaces)..add(created);
          emit(ParkingSpaceLoaded(updatedList));
        } catch (e) {
          emit(ParkingSpaceError('Failed to add ParkingSpace: $e'));
        }
      }
    });

     on<UpdateParkingSpace>((event, emit) async {
      if (state is ParkingSpaceLoaded) {
        try {
          await repository.update(event.parkingSpace.id, event.parkingSpace);
        
          final updatedList = (state as ParkingSpaceLoaded).ParkingSpaces
              .map<ParkingSpace>((p) { 
                return p.id == event.parkingSpace.id ? event.parkingSpace : p;
              })
              .toList();

          emit(ParkingSpaceLoaded(updatedList));
        } catch (e) {
          emit(ParkingSpaceError('Failed to update ParkingSpace: $e'));
        }
      }
    });

    on<DeleteParkingSpace>((event, emit) async {
      if (state is ParkingSpaceLoaded) {
        try {
          await repository.deleteById(event.id);
          final updatedList = (state as ParkingSpaceLoaded).ParkingSpaces.where((p) => p.id != event.id).toList();
          emit(ParkingSpaceLoaded(updatedList));
        } catch (e) {
          emit(ParkingSpaceError('Failed to delete ParkingSpace: $e'));
        }
      }
    });
  }
}
