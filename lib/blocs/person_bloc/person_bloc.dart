import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/repositories/personRepository.dart';
import 'person_event.dart';
import 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository _personRepository = PersonRepository.instance;

  PersonBloc() : super(PersonInitial()) {
    on<LoadPersons>(_onLoadPersons);
    on<AddPerson>(_onAddPerson);
    on<UpdatePerson>(_onUpdatePerson);
    on<DeletePerson>(_onDeletePerson);
  }

  Future<void> _onLoadPersons(LoadPersons event, Emitter<PersonState> emit) async {
    emit(PersonLoading());
    try {
      final persons = await _personRepository.findAll();
      emit(PersonLoaded(persons));
    } catch (e) {
      emit(PersonError('Failed to load persons: $e'));
    }
  }

  Future<void> _onAddPerson(AddPerson event, Emitter<PersonState> emit) async {
    try {
      await _personRepository.add(event.person);
      add(LoadPersons()); 
    } catch (e) {
      emit(PersonError('Failed to add person: $e'));
    }
  }

  Future<void> _onUpdatePerson(UpdatePerson event, Emitter<PersonState> emit) async {
    try {
      await _personRepository.update(event.id, event.updatedPerson);
      add(LoadPersons());
    } catch (e) {
      emit(PersonError('Failed to update person: $e'));
    }
  }

  Future<void> _onDeletePerson(DeletePerson event, Emitter<PersonState> emit) async {
    try {
      await _personRepository.deleteById(event.id);
      add(LoadPersons());
    } catch (e) {
      emit(PersonError('Failed to delete person: $e'));
    }
  }
}
