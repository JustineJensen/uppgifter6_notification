class Person {
  final int id; 
  late String _namn;
  late int _personNummer;

  // Constructor
  Person({
    this.id = 0,
    required String namn,
    required int personNummer
  })  : _namn = namn,
        _personNummer = personNummer;

  // Getters
  String get namn => _namn;
  int get personNummer => _personNummer;

  // Setters
  set namn(String namn) => _namn = namn;

  set personNummer(int personNummer) {
    if (personNummer.toString().length == 12) {
      _personNummer = personNummer;
    } else {
      throw Exception("Person number must be 12 digits");
    }
  }
 Person copyWith({
  int? id,
  String? namn,
  int? personNummer,
}) {
  return Person(
    id: id ?? this.id,
    namn: namn ?? this.namn,
    personNummer: personNummer ?? this.personNummer,
  );
}


  // JSON Serialization
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0,
      namn: json['namn'] ?? '',
      personNummer: json['personNummer'] ?? 0,
    );
  }

 Map<String, dynamic> toJson() {
  return {
    'id': id, 
    'namn': namn,
    'personNummer': personNummer,
  };
}

  @override
  String toString() {
    return 'Person(namn: $namn, personNummer: $personNummer, id: $id)';
  }
}