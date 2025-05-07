import 'package:equatable/equatable.dart';
import 'package:uppgift1/models/person.dart';

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
  final int id;
  final Person updatedPerson;

  UpdatePerson(this.id, this.updatedPerson);

  @override
  List<Object?> get props => [id, updatedPerson];
}

class DeletePerson extends PersonEvent {
  final int id;

  DeletePerson(this.id);

  @override
  List<Object?> get props => [id];
}
