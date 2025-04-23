import 'package:flutter/material.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/personRepository.dart';

class PersonView extends StatefulWidget {
  const PersonView({super.key});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  late Future<List<Person>> _futurePersons;

  @override
  void initState() {
    super.initState();
    _futurePersons = PersonRepository.instance.findAll();
  }

  // Function to load persons
  void _loadPersons() {
    setState(() {
      _futurePersons = PersonRepository.instance.findAll();
    });
  }

  // Function to show the dialog for adding or updating a person
  void _showPersonDialog({Person? person}) {
    final nameController = TextEditingController(text: person?.namn ?? '');
    final numberController = TextEditingController(
      text: person?.personNummer.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            onPressed: () async {
              final name = nameController.text.trim();
              final personnummerString = numberController.text.trim();

              if (name.isEmpty || personnummerString.isEmpty) return;

              final personnummer = int.tryParse(personnummerString);
              if (personnummer == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Personnummer must be a 12-digit number')),
                );
                return;
              }

              try {
                if (person == null) {
                  // If `person` is null, add a new person
                  await PersonRepository.instance.add(
                    Person(namn: name, personNummer: personnummer),
                  );
                } else {
                  // If `person` is not null, update the existing person
                  await PersonRepository.instance.update(
                    person.id,
                    Person(id: person.id, namn: name, personNummer: personnummer), 
                  );
                }

                Navigator.pop(context); // Close the dialog
                _loadPersons(); // Reload the list after adding or updating
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

  // Function to handle 'View All Persons' button press
  void _viewAllPersons() {
    setState(() {
      _futurePersons = PersonRepository.instance.findAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Person"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _viewAllPersons,
            child: const Text('View All Persons'),
          ),
          
          // Button to add a new person
          ElevatedButton(
            onPressed: () => _showPersonDialog(), 
            child: const Text('Add New Person'),
          ),
          
         
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
                      subtitle: Text('ID: ${person.id}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showPersonDialog(person: person),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await PersonRepository.instance.deleteById(person.id);
                              _loadPersons(); 
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
    );
  }
}
