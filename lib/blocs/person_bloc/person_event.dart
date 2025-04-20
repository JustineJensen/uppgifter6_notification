// lib/blocs/person_bloc/person_event.dart
import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/person.dart';

abstract class PersonEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPersons extends PersonEvent {}

class AddPerson extends PersonEvent {
  final Person person;

  AddPerson(this.person);

  @override
  List<Object?> get props => [person];
}

class UpdatePerson extends PersonEvent {
  final Person person;

  UpdatePerson(this.person);

  @override
  List<Object?> get props => [person];
}

class DeletePerson extends PersonEvent {
  final String id;

  DeletePerson(this.id);

  @override
  List<Object?> get props => [id];
}

