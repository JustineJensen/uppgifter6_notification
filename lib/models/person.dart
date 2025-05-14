class Person {
  static int _idCounter = 0;
  final int id;
  late String _namn;
  late int _personNummer;

  // Constructor
  Person({
    required String namn,
    required int personNummer,
    int? id, 
  })  : _namn = namn,
        _personNummer = personNummer,
        id = id ?? ++_idCounter; 

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

  // JSON Serialization
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'], 
      namn: json['namn'],
      personNummer: json['personNummer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "namn": namn,
      "personNummer": personNummer,
    };
  }

  // Copy with new ID
  Person copyWith({int? id}) {
    return Person(
      id: id ?? this.id,
      namn: namn,
      personNummer: personNummer,
    );
  }

  @override
  String toString() {
    return 'Person(namn: $namn, personNummer: $personNummer, id: $id)';
  }
}
