import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_event.dart';
import 'package:uppgift3_new_app/blocs/vehicle_bloc/vehicle_state.dart';

import '../mocks/mock_vehicle_repository.dart';


void main() {
  late MockVehicleRepository mockRepository;
  late VehicleBloc vehicleBloc;

  final testCar = Car(
    id: 1,
    registreringsNummer: 'ABC123',
    typ: VehicleType.Bil,
    owner: Person(namn: 'Rita', personNummer: 123456789876),
    color: 'red',
  );

  setUp(() {
    mockRepository = MockVehicleRepository();
    vehicleBloc = VehicleBloc(mockRepository);
  });

  tearDown(() {
    vehicleBloc.close();
  });

  group('VehicleBloc Tests', () {
    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehiclesLoaded] when LoadVehicles is added',
      build: () {
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testCar]);
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(LoadVehicles()),
      expect: () => [
        VehicleLoading(),
        VehiclesLoaded([testCar]),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleOperationSuccess] when AddVehicle is added',
      build: () {
        when(() => mockRepository.add(testCar)).thenAnswer((_) async => testCar);
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(AddVehicle(testCar)),
      expect: () => [
        VehicleLoading(),
        VehicleOperationSuccess(),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleLoaded] when FindVehicleById is added',
      build: () {
        when(() => mockRepository.findById(1)).thenAnswer((_) async => testCar);
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(FindVehicleById(1)),
      expect: () => [
        VehicleLoading(),
        VehicleLoaded(testCar),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleError] when repository throws on FindVehicleById',
      build: () {
        when(() => mockRepository.findById(99)).thenThrow(Exception('Not Found'));
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(FindVehicleById(99)),
      expect: () => [
        VehicleLoading(),
        isA<VehicleError>(),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleOperationSuccess] when DeleteVehicle is added',
      build: () {
        when(() => mockRepository.deleteById(1)).thenAnswer((_) async {});
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(DeleteVehicle(1)),
      expect: () => [
        VehicleLoading(),
        VehicleOperationSuccess(),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleOperationSuccess] when UpdateVehicle is added',
      build: () {
        when(() => mockRepository.update(1, testCar)).thenAnswer((_) async => testCar);
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(UpdateVehicle(1, testCar)),
      expect: () => [
        VehicleLoading(),
        VehicleOperationSuccess(),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleLoaded] when FindVehicleByRegNum is added',
      build: () {
        when(() => mockRepository.findByRegNum('ABC123')).thenAnswer((_) async => testCar);
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(FindVehicleByRegNum('ABC123')),
      expect: () => [
        VehicleLoading(),
        VehicleLoaded(testCar),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleError] when DeleteVehicle throws',
      build: () {
        when(() => mockRepository.deleteById(1)).thenThrow(Exception('delete error'));
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(DeleteVehicle(1)),
      expect: () => [
        VehicleLoading(),
        isA<VehicleError>(),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleError] when UpdateVehicle throws',
      build: () {
        when(() => mockRepository.update(1, testCar)).thenThrow(Exception('update error'));
        return vehicleBloc;
      },
      act: (bloc) => bloc.add(UpdateVehicle(1, testCar)),
      expect: () => [
        VehicleLoading(),
        isA<VehicleError>(),
      ],
    );
  });
}
