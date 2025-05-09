import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift3_new_app/repositories/parkingSpaceRepository.dart';

// Mock ParkingSpaceRepository
class MockParkingSpaceRepository extends Mock implements ParkingSpaceRepository {}

void main() {
  late MockParkingSpaceRepository mockRepository;
  late ParkingSpaceBloc bloc;

  final testSpace = ParkingSpace(id: 1, adress: 'Lund', pricePerHour: 10.0);

  setUp(() {
    mockRepository = MockParkingSpaceRepository();
    bloc = ParkingSpaceBloc();
  });

  tearDown(() {
    bloc.close();
  });

  group('ParkingSpaceBloc Tests', () {
    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceLoading, ParkingSpaceLoaded] when LoadParkingSpaces is added',
      build: () {
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testSpace]);
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(LoadParkingSpaces()),
      expect: () => [
        ParkingSpaceLoading(),
        ParkingSpaceLoaded([testSpace]),
      ],
    );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceError] when repository throws on LoadParkingSpaces',
      build: () {
        when(() => mockRepository.findAll()).thenThrow(Exception('Error'));
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(LoadParkingSpaces()),
      expect: () => [
        ParkingSpaceLoading(),
        isA<ParkingSpaceError>(),
      ],
    );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'calls add and then emits [ParkingSpaceLoading, ParkingSpaceLoaded] when AddParkingSpace is added',
      build: () {
        when(() => mockRepository.add(testSpace)).thenAnswer((_) async => testSpace);
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testSpace]);
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(AddParkingSpace(testSpace)),
      expect: () => [
        ParkingSpaceLoading(),
        ParkingSpaceLoaded([testSpace]),
      ],
    );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceError] when repository throws on AddParkingSpace',
      build: () {
        when(() => mockRepository.add(testSpace)).thenThrow(Exception('Add failed'));
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(AddParkingSpace(testSpace)),
      expect: () => [
        isA<ParkingSpaceError>(),
      ],
    );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'calls update and emits [ParkingSpaceLoading, ParkingSpaceLoaded] on UpdateParkingSpace',
      build: () {
        when(() => mockRepository.update(1, testSpace)).thenAnswer((_) async => testSpace);
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testSpace]);
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(UpdateParkingSpace(1, testSpace)),
      expect: () => [
        ParkingSpaceLoading(),
        ParkingSpaceLoaded([testSpace]),
      ],
    );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'calls delete and emits [ParkingSpaceLoading, ParkingSpaceLoaded] on DeleteParkingSpace',
      build: () {
        when(() => mockRepository.deleteById(1)).thenAnswer((_) async => {});
        when(() => mockRepository.findAll()).thenAnswer((_) async => []);
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(DeleteParkingSpace(1)),
      expect: () => [
        ParkingSpaceLoading(),
        ParkingSpaceLoaded([]),
      ],
    );
    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceError] when repository throws on UpdateParkingSpace',
      build: () {
        when(() => mockRepository.update(1, testSpace)).thenThrow(Exception('Update failed'));
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(UpdateParkingSpace(1, testSpace)),
      expect: () => [
        isA<ParkingSpaceError>(),
      ],
    );
      blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceError] when repository throws on DeleteParkingSpace',
      build: () {
        when(() => mockRepository.deleteById(1)).thenThrow(Exception('Delete failed'));
        return ParkingSpaceBloc();
      },
      act: (bloc) => bloc.add(DeleteParkingSpace(1)),
      expect: () => [
        isA<ParkingSpaceError>(),
      ],
    );
  });
}
