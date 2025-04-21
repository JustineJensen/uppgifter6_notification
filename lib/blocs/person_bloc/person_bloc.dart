import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_state.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/repositories/person_repository.dart';
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;

  PersonBloc({required this.repository}) : super(PersonInitial()) {
    on<LoadPersons>((event, emit) async {
      emit(PersonLoading());
      try {
        final persons = await repository.findAll();
        emit(PersonLoaded(persons));
      } catch (e) {
        emit(PersonError('Failed to load persons: $e'));
      }
    });

      on<AddPerson>((event, emit) async {
      emit(PersonLoading()); 
      try {
        await repository.add(event.person); 
        final allPersons = await repository.findAll(); 
        emit(PersonLoaded(allPersons));
      } catch (e) {
        emit(PersonError('Failed to add person: $e'));
      }
    });

      on<UpdatePerson>((event, emit) async {
      if (state is PersonLoaded) {
        try {

          await repository.update(event.person.id, event.person);
          final updatedList = (state as PersonLoaded).persons.map((p) {
            return p.id == event.person.id ? event.person : p;
          }).toList();

          emit(PersonLoaded(updatedList));
        } catch (e) {
          emit(PersonError('Failed to update person: $e'));
        }
      }
    });

    on<DeletePerson>((event, emit) async {
      try {
        await repository.deleteById(event.id);
        final persons = await repository.findAll();
        emit(PersonLoaded(persons));
      } catch (e) {
        emit(PersonError('Failed to delete person: $e'));
      }
    });

  }
}