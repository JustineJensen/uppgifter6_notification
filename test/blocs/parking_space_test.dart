import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_bloc.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_event.dart';
import 'package:uppgift3_new_app/blocs/parkingspace_bloc/parkingspace_state_bloc.dart';
import 'package:uppgift3_new_app/models/parkingSpace.dart';
import '../mocks/mock_parking_space_repository.dart';

void main() {
  late MockParkingSpaceRepository mockRepository;
  late ParkingSpaceBloc bloc;

  final testSpace = ParkingSpace(id: 1, adress: 'Lund', pricePerHour: 10.0);

  setUp(() {
    mockRepository = MockParkingSpaceRepository();
    bloc = ParkingSpaceBloc(mockRepository); 
  });

  tearDown(() {
    bloc.close();
  });

  group('ParkingSpaceBloc Tests', () {
    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceLoading, ParkingSpaceLoaded] when LoadParkingSpaces is added',
      build: () {
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testSpace]);
        return ParkingSpaceBloc(mockRepository); 
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
        return ParkingSpaceBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoadParkingSpaces()),
      expect: () => [
        ParkingSpaceLoading(),
        isA<ParkingSpaceError>().having(
          (e) => e.message, 
          'message', 
          contains('Error'),
        ),
      ],
    );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'calls add and then emits [ParkingSpaceLoading, ParkingSpaceLoaded] when AddParkingSpace is added',
    build: () {
      when(() => mockRepository.add(testSpace)).thenAnswer((_) async => testSpace);
      when(() => mockRepository.findAll()).thenAnswer((_) async => [testSpace]);
      return ParkingSpaceBloc(mockRepository);
    },
    act: (bloc) => bloc.add(AddParkingSpace(testSpace)),
    expect: () => [
      ParkingSpaceLoading(),
      ParkingSpaceLoaded([testSpace]),
    ],
    verify: (_) {
      verify(() => mockRepository.add(testSpace)).called(1);
      verify(() => mockRepository.findAll()).called(1);
    },
  );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'emits [ParkingSpaceError] when repository throws on AddParkingSpace',
      build: () {
        when(() => mockRepository.add(testSpace)).thenThrow(Exception('Add failed'));
        return ParkingSpaceBloc(mockRepository);
      },
      act: (bloc) => bloc.add(AddParkingSpace(testSpace)),
      expect: () => [
        isA<ParkingSpaceError>().having(
          (e) => e.message,
          'message',
          contains('Add failed'),
        ),
      ],
    );

   blocTest<ParkingSpaceBloc, ParkingSpaceState>(
      'calls update and emits [ParkingSpaceLoading, ParkingSpaceLoaded] on UpdateParkingSpace',
      build: () {
        when(() => mockRepository.update(1, testSpace)).thenAnswer((_) async => testSpace);
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testSpace]);
        return ParkingSpaceBloc(mockRepository);
      },
      act: (bloc) => bloc.add(UpdateParkingSpace(1, testSpace)),
      expect: () => [
        ParkingSpaceLoading(),
        ParkingSpaceLoaded([testSpace]),
      ],
      verify: (_) {
        verify(() => mockRepository.update(1, testSpace)).called(1);
        verify(() => mockRepository.findAll()).called(1);
      },
    );

      blocTest<ParkingSpaceBloc, ParkingSpaceState>(
        'emits [ParkingSpaceError] when repository throws on UpdateParkingSpace',
        build: () {
          when(() => mockRepository.update(1, testSpace))
            .thenThrow(Exception('Update failed'));
          return ParkingSpaceBloc(mockRepository); 
        },
        act: (bloc) => bloc.add(UpdateParkingSpace(1, testSpace)),
        expect: () => [
          isA<ParkingSpaceError>()
            .having((e) => e.message, 'message', contains('Update failed')),
        ],
        verify: (_) {
          verify(() => mockRepository.update(1, testSpace)).called(1);
          verifyNever(() => mockRepository.findAll());
        },
      );

    blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'calls delete and emits [ParkingSpaceLoading, ParkingSpaceLoaded] on DeleteParkingSpace',
    build: () {
      when(() => mockRepository.deleteById(1)).thenAnswer((_) async {});
      when(() => mockRepository.findAll()).thenAnswer((_) async => []);
      return ParkingSpaceBloc(mockRepository);
    },
    act: (bloc) => bloc.add(DeleteParkingSpace(1)),
    expect: () => [
      ParkingSpaceLoading(),
      ParkingSpaceLoaded([]),
    ],
  );

  blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'emits [ParkingSpaceError] when repository throws on DeleteParkingSpace',
    build: () {
      when(() => mockRepository.deleteById(1)).thenThrow(Exception('Delete failed'));
      return ParkingSpaceBloc(mockRepository);
    },
    act: (bloc) => bloc.add(DeleteParkingSpace(1)),
    expect: () => [
      isA<ParkingSpaceError>().having(
        (e) => e.message,
        'message',
        contains('Delete failed'),
      ),
    ],
  );

  blocTest<ParkingSpaceBloc, ParkingSpaceState>(
  'emits [ParkingSpaceError] when repository throws on DeleteParkingSpace',
  build: () {
    when(() => mockRepository.deleteById(1)).thenThrow(Exception('Delete failed'));
    return ParkingSpaceBloc(mockRepository);
  },
  act: (bloc) => bloc.add(DeleteParkingSpace(1)),
  expect: () => [
    isA<ParkingSpaceError>().having(
      (e) => e.message,
      'message',
      contains('Delete failed'),
    ),
  ],
);
});
}
