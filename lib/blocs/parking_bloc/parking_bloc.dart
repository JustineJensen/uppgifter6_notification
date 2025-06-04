import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/models/parking.dart';
import 'package:uppgift3_new_app/repositories/notification_repository.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';
import 'parking_event.dart';
import 'parking_state.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;


class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingRepository _parkingRepository;
  final NotificationRepository _notificationRepository;
 
  ParkingBloc(this._parkingRepository,this._notificationRepository) : super(ParkingInitial()) {
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

    final parking = event.parking;
    final endTime = parking.endTime;

    if (endTime != null) {
      final regNumber = parking.fordon.registreringsNummer;
      final tzTime = tz.TZDateTime.from(endTime, tz.local);
      final formattedTime = DateFormat.Hm().format(tzTime);
      await _notificationRepository.scheduleParkingReminder(
        id: _safeNotificationId(parking, 0),
        title: 'Parkering går snart ut!',
        content: 'Din parkering för $regNumber går ut om 5 minuter! ($formattedTime)',
        endTime: endTime,
        reminderTime: const Duration(minutes: 5),
      );
      await _notificationRepository.scheduleParkingReminder(
        id: _safeNotificationId(parking, 1),
        title: 'Parkeringstid är slut!',
        content: 'Din parkering för $regNumber har gått ut.',
        endTime: endTime,
        reminderTime: Duration.zero,
      );
    }
  } catch (e) {
    emit(ParkingError('Failed to add parking: $e'));
  }
}



  Future<void> _onUpdateParking(UpdateParking event, Emitter<ParkingState> emit) async {
  try {
    await _parkingRepository.update(event.id, event.updatedParking);

    final parking = event.updatedParking;
    final endTime = parking.endTime;

    if (endTime != null) {
      final regNumber = parking.fordon.registreringsNummer;

      await _notificationRepository.scheduleParkingReminder(
        id: _safeNotificationId(parking, 0),
        title: "Parkering går snart ut",
        content: "Din parkering för $regNumber går ut om 5 minuter!",
        endTime: endTime,
        reminderTime: const Duration(minutes: 5),
      );

      await _notificationRepository.scheduleParkingReminder(
        id: _safeNotificationId(parking, 1),
        title: "Parkering avslutad",
        content: "Din parkering för $regNumber har nu gått ut.",
        endTime: endTime,
        reminderTime: Duration.zero,
      );
    }

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

  int _safeNotificationId(Object object, int offset) {

  return object.hashCode.abs() % 1000000000 + offset;
}
}
