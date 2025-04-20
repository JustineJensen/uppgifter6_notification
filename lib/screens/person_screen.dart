import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_bloc.dart';
import 'package:uppgift3_new_app/blocs/person_bloc/person_event.dart';
import 'package:uppgift3_new_app/models/person.dart';
import 'package:uppgift3_new_app/repositories/person_repository.dart';

class PersonScreenContent extends StatelessWidget {
  const PersonScreenContent({Key? key}) : super(key: key);

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
                  builder: (context) {
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
                          onPressed: () {
                            Navigator.pop(context); 
                          },
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
                            Navigator.pop(context);
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
                MaterialPageRoute(builder: (_) => const PersonScreenContent())

                );
              }),
              _buildOption(context, 'Update Person', Icons.edit, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Select a person to update in 'View All'")),
                );
              }),
              _buildOption(context, 'Delete Person', Icons.delete, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Long-press in 'View All' to delete")),
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
