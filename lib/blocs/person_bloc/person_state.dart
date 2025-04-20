// lib/blocs/person/person_state.dart
import 'package:equatable/equatable.dart';
import 'package:uppgift3_new_app/models/person.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object?> get props => [];
}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> persons;

  const PersonLoaded(this.persons);

  @override
  List<Object?> get props => [persons];
}

class PersonError extends PersonState {
  final String message;

  const PersonError(this.message);

  @override
  List<Object?> get props => [message];
}
