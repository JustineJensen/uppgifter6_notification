import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_state.dart';
import 'package:uppgift3_new_app/repositories/personRepository.dart';

class MockPersonRepository extends Mock implements PersonRepository {}

void main() {
  late MockPersonRepository mockRepository;
  late PersonBloc personBloc;

  final testPerson = Person(id: 1, namn: 'Alice', personNummer: 123456789);

  setUp(() {
    mockRepository = MockPersonRepository();
    PersonRepository.instance = mockRepository; 
    personBloc = PersonBloc();

  
  });

  tearDown(() {
    personBloc.close();
  });

  group('PersonBloc Tests', () {
    blocTest<PersonBloc, PersonState>(
      'emits [PersonLoading, PersonLoaded] when LoadPersons is added',
      build: () {
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testPerson]);
        return personBloc;
      },
      act: (bloc) => bloc.add(LoadPersons()),
      expect: () => [
        PersonLoading(),
        PersonLoaded([testPerson]),
      ],
    );

    blocTest<PersonBloc, PersonState>(
      'emits [PersonError] when repository throws on LoadPersons',
      build: () {
        when(() => mockRepository.findAll()).thenThrow(Exception('load error'));
        return personBloc;
      },
      act: (bloc) => bloc.add(LoadPersons()),
      expect: () => [
        PersonLoading(),
        isA<PersonError>(),
      ],
    );

    blocTest<PersonBloc, PersonState>(
      'emits [PersonError] when repository throws on AddPerson',
      build: () {
        when(() => mockRepository.add(testPerson)).thenThrow(Exception('add error'));
        return personBloc;
      },
      act: (bloc) => bloc.add(AddPerson(testPerson)),
      expect: () => [
        isA<PersonError>(),
      ],
    );

    blocTest<PersonBloc, PersonState>(
      'emits [PersonError] when repository throws on UpdatePerson',
      build: () {
        when(() => mockRepository.update(1, testPerson)).thenThrow(Exception('update error'));
        return personBloc;
      },
      act: (bloc) => bloc.add(UpdatePerson(1, testPerson)),
      expect: () => [
        isA<PersonError>(),
      ],
    );

    blocTest<PersonBloc, PersonState>(
      'emits [PersonError] when repository throws on DeletePerson',
      build: () {
        when(() => mockRepository.deleteById(1)).thenThrow(Exception('delete error'));
        return personBloc;
      },
      act: (bloc) => bloc.add(DeletePerson(1)),
      expect: () => [
        isA<PersonError>(),
      ],
    );

    blocTest<PersonBloc, PersonState>(
      'emits [PersonLoaded] after successful AddPerson and LoadPersons',
      build: () {
        when(() => mockRepository.add(testPerson)).thenAnswer((_) async => testPerson);
        when(() => mockRepository.findAll()).thenAnswer((_) async => [testPerson]);
        return personBloc;
      },
      act: (bloc) => bloc.add(AddPerson(testPerson)),
      expect: () => [
        PersonLoading(),
        PersonLoaded([testPerson]),
      ],
      );
      blocTest<PersonBloc, PersonState>(
        'emits [PersonError] when add throws (AddPerson)',
        build: () {
          when(() => mockRepository.add(testPerson))
              .thenThrow(Exception('add error'));
          return personBloc;
        },
        act: (bloc) => bloc.add(AddPerson(testPerson)),
        expect: () => [
          isA<PersonError>()
              .having((e) => e.message, 'message', contains('add error')),
        ],
      );
      blocTest<PersonBloc, PersonState>(
        'emits [PersonError] when update throws (UpdatePerson)',
        build: () {
          when(() => mockRepository.update(1, testPerson))
              .thenThrow(Exception('update error'));
          return personBloc;
        },
        act: (bloc) => bloc.add(UpdatePerson(1, testPerson)),
        expect: () => [
          isA<PersonError>()
              .having((e) => e.message, 'message', contains('update error')),
        ],
      );
      
    });
  
}
