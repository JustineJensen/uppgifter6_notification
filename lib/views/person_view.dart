import 'package:flutter/material.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift3_new_app/repositories/personRepository.dart';

class PersonView extends StatefulWidget {
  const PersonView({super.key});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  Future<List<Person>>? _futurePersons;

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
            onPressed: () async {
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

              try {
                if (person == null) {
                  await PersonRepository.instance.add(
                    Person(namn: name, personNummer: pnr),
                  );
                } else {
                  final newPerson = Person(
                    id: person.id,
                    namn: name,
                    personNummer: pnr,
                  );
                  await PersonRepository.instance.update(person.id, newPerson);
                }
              
                Navigator.pop(context);
              
                setState(() {
                  _futurePersons = PersonRepository.instance.findAll();
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: Text(person == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _viewAllPersons() {
    setState(() {
      _futurePersons = PersonRepository.instance.findAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            if (_futurePersons != null)
              Expanded(
                child: FutureBuilder<List<Person>>(
                  future: _futurePersons,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No persons found.'));
                    }

                    final persons = snapshot.data!;
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
                                onPressed: () async {
                                  await PersonRepository.instance.deleteById(person.id!);
                                  _viewAllPersons();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}