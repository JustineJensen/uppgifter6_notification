import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_state.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/repositories/person_repository.dart';

class PersonScreenContent extends StatelessWidget {
  const PersonScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonBloc(repository: PersonRepository.instance)..add(LoadPersons()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Persons'),
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOption(context, 'Add New Person', Icons.person_add, () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    final nameController = TextEditingController();
                    final personNummerController = TextEditingController();

                    return AlertDialog(
                      title: const Text('Add New Person'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: 'Name'),
                          ),
                          TextField(
                            controller: personNummerController,
                            decoration: const InputDecoration(labelText: 'Personnummer (12 digits)'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            final namn = nameController.text.trim();
                            final pnr = int.tryParse(personNummerController.text.trim());

                            if (namn.isEmpty || pnr == null || personNummerController.text.length != 12) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please enter valid data (12-digit personnummer).")),
                              );
                              return;
                            }

                            final newPerson = Person(namn: namn, personNummer: pnr);
                            context.read<PersonBloc>().add(AddPerson(newPerson));  
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              }),
              _buildOption(context, 'View All Persons', Icons.people, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<PersonBloc>(context),
                      child: const ViewPersonsScreen(),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}

class ViewPersonsScreen extends StatelessWidget {
  const ViewPersonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Persons'),
      ),
      body: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          if (state is PersonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PersonLoaded) {
            final persons = state.persons;
            return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return Dismissible(
                  key: Key(person.id.toString()),
                  onDismissed: (direction) {
                    context.read<PersonBloc>().add(DeletePerson(person.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted ${person.namn}')),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(person.namn),
                    subtitle: Text('Personnummer: ${person.personNummer}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, person),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<PersonBloc>().add(DeletePerson(person.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Deleted ${person.namn}')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } 
          return const SizedBox();
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Person person) {
    final nameController = TextEditingController(text: person.namn);
    final pnrController = TextEditingController(text: person.personNummer.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: pnrController,
              decoration: const InputDecoration(labelText: 'Personnummer'),
              keyboardType: TextInputType.number,
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
              final newName = nameController.text.trim();
              final newPnr = int.tryParse(pnrController.text.trim());

              if (newName.isEmpty || newPnr == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid input")),
                );
                return;
              }

              final updatedPerson = person.copyWith(namn: newName, personNummer: newPnr);
              context.read<PersonBloc>().add(UpdatePerson(updatedPerson));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}