import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uppgift3_new_app/blocs/person_bloc/person_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_state.dart';
import 'package:uppgift3_new_app/models/person.dart';

class PersonView extends StatefulWidget {
  const PersonView({super.key});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  void _showPersonDialog({Person? person}) {
    final nameController = TextEditingController(text: person?.namn ?? '');
    final numberController = TextEditingController(
      text: person?.personNummer.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(person == null ? 'Add Person' : 'Update Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Personnummer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final pnrStr = numberController.text.trim();

              if (name.isEmpty || pnrStr.isEmpty) return;

              final pnr = int.tryParse(pnrStr);
              if (pnr == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Personnummer must be a number')),
                );
                return;
              }

              if (person == null) {
                context.read<PersonBloc>().add(
                  AddPerson(Person(namn: name, personNummer: pnr)),
                );
              } else {
                context.read<PersonBloc>().add(
                UpdatePerson(
                  person.id!,
                  Person(id: person.id, namn: name, personNummer: pnr), 
                ),
              );

              }

              Navigator.pop(context); 
            },
            child: Text(person == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _viewAllPersons() {
    context.read<PersonBloc>().add(LoadPersons());
  }

  @override
  void initState() {
    super.initState();
    _viewAllPersons();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonBloc, PersonState>(
      listener: (context, state) {
        if (state is PersonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is PersonLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Operation successful")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Manage Person")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => _showPersonDialog(),
                child: const Text('Add New Person'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _viewAllPersons,
                child: const Text('View All Persons'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<PersonBloc, PersonState>(
                  builder: (context, state) {
                    if (state is PersonLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PersonError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is PersonLoaded) {
                      final persons = state.persons;
                      if (persons.isEmpty) {
                        return const Center(child: Text('No persons found.'));
                      }
                      return ListView.builder(
                        itemCount: persons.length,
                        itemBuilder: (context, index) {
                          final person = persons[index];
                          return ListTile(
                            title: Text(person.namn),
                            subtitle: Text('ID: ${person.id} | Personnummer: ${person.personNummer}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showPersonDialog(person: person);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    context.read<PersonBloc>().add(
                                    DeletePerson(person.id!),
                                  );

                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
