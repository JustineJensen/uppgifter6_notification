import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_event.dart'; 
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_state.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart'; 
import 'package:uppgift3_new_app/repositories/parking_repository.dart'; 
import 'package:uppgift3_new_app/repositories/parking_space_repository.dart'; 

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingRepository parkingRepository;
  
  ParkingBloc({
    required this.parkingRepository,
  }) : super(ParkingInitial());

  @override
Stream<ParkingState> mapEventToState(ParkingEvent event) async* {
  if (event is LoadParkings) {
    yield ParkingLoading();
    try {
      final parkings = await parkingRepository.findAll();
      yield ParkingLoaded(parkings);
    } catch (e) {
      yield ParkingOperationFailure(e.toString());
    }
  } else if (event is AddParking) {
    yield ParkingLoading();
    try {
      final parking = await parkingRepository.add(event.parking);
      yield ParkingAdded(parking);
      add(LoadParkings());
    } catch (e) {
      yield ParkingOperationFailure(e.toString());
    }
  } else if (event is DeleteParking) {
    yield ParkingLoading();
    try {
      await parkingRepository.deleteByDocId(event.parkingId.toString());
      yield ParkingDeleted(event.parkingId);
      add(LoadParkings());
    } catch (e) {
      yield ParkingOperationFailure(e.toString());
    }
  } else if (event is UpdateParking) {
    yield ParkingLoading();
    try {
      final updatedParking = await parkingRepository.update(
          event.parkingId, event.updatedParking);
      yield ParkingUpdated(updatedParking);
      add(LoadParkings());
    } catch (e) {
      yield ParkingOperationFailure(e.toString());
    }
  }
}
}
