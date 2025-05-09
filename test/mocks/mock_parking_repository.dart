import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_bloc.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_event.dart';
import 'package:uppgift3_new_app/blocs/parking_bloc/parking_state.dart';
import 'package:uppgift3_new_app/repositories/parkingRepository.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

void main() {
  late MockParkingRepository mockRepository;
  late ParkingBloc parkingBloc;
  

 final testPerson = Person(namn: 'Test User', personNummer: 1234567890);

final testCar = Car(
  id: 1,
  registreringsNummer: 'ABC123',
  typ: VehicleType.Bil,
  owner: testPerson,
  color: 'Red',
);

final testParkingSpace = ParkingSpace(
  id: 1,
  adress: '', pricePerHour: 1.0,
);

final testParking = Parking(
  id: 1,
  fordon: testCar,
  parkingSpace: testParkingSpace,
  startTime: DateTime.now(),
);
  setUp(() {
    mockRepository = MockParkingRepository();
    mockRepository = MockParkingRepository();
    parkingBloc = ParkingBloc(mockRepository);
  });

  tearDown(() {
    parkingBloc.close();
  });

  group('ParkingBloc Tests', () {
    blocTest<ParkingBloc, ParkingState>(
      'emits [ParkingLoading, ParkingLoaded] when LoadParkings is added',
      build: () {
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testParking]);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadParkings()),
      expect: () => [
        ParkingLoading(),
        ParkingLoaded([testParking]),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'emits [ParkingError] when repository throws on LoadParkings',
      build: () {
        when(() => mockRepository.findAll()).thenThrow(Exception('Error'));
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadParkings()),
      expect: () => [
        ParkingLoading(),
        isA<ParkingError>(),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'calls add and then emits [ParkingLoading, ParkingLoaded] when AddParking is added',
      build: () {
        when(() => mockRepository.add(testParking)).thenAnswer((_) async => testParking);
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testParking]);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(AddParking(testParking)),
      expect: () => [
        ParkingLoading(),
        ParkingLoaded([testParking]),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'emits [ParkingError] when repository throws on AddParking',
      build: () {
        when(() => mockRepository.add(testParking)).thenThrow(Exception('Add failed'));
        return parkingBloc;
      },
      act: (bloc) => bloc.add(AddParking(testParking)),
      expect: () => [
        isA<ParkingError>(),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'calls update and emits [ParkingLoading, ParkingLoaded] on UpdateParking',
      build: () {
        when(() => mockRepository.update(1, testParking)).thenAnswer((_) async => testParking);
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testParking]);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(UpdateParking(1, testParking)),
      expect: () => [
        ParkingLoading(),
        ParkingLoaded([testParking]),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'calls delete and emits [ParkingLoading, ParkingLoaded] on DeleteParking',
      build: () {
        when(() => mockRepository.deleteById(1)).thenAnswer((_) async => {});
        when(() => mockRepository.findAll()).thenAnswer((_) async => []);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(DeleteParking(1)),
      expect: () => [
        ParkingLoading(),
        ParkingLoaded([]),
      ],
    );
    });
    blocTest<ParkingBloc, ParkingState>(
    'emits [ParkingError] when network error occurs on AddParking',
    build: () {
      when(() => mockRepository.add(testParking)).thenThrow(SocketException('Network Error'));
      return parkingBloc;
    },
    act: (bloc) => bloc.add(AddParking(testParking)),
    expect: () => [
      isA<ParkingError>(),  
    ],
  );
    blocTest<ParkingBloc, ParkingState>(
    'emits [ParkingError] when request times out on UpdateParking',
    build: () {
      when(() => mockRepository.update(1, testParking)).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 10));  
        throw TimeoutException('Request timed out');
      });
      return parkingBloc;
    },
    act: (bloc) => bloc.add(UpdateParking(1, testParking)),
    expect: () => [
      isA<ParkingError>(), 
    ],
);


}
