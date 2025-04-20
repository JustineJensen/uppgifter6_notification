
import 'dart:core';

class ParkingSpace {
  late int _id;
  late String _adress;
   final double _pricePerHour;
  
//constructor
ParkingSpace({
required  String adress, 
required double pricePerHour,
required int id,

}) :
_id = id,
_adress = adress,
_pricePerHour = pricePerHour;

//Getters
int get id => _id;
String get adress => _adress;
double get pricePerHour => _pricePerHour;

//Setters
set adress(String adress)=>_adress= adress;

 factory ParkingSpace.fromJson( Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'],  
      adress: json['adress'], 
      pricePerHour: json['pricePerHour'], 
    );
}
  Map<String, dynamic> toJson(){
    return{
      "id": id,
      "adress":adress,
      "pricePerHour": pricePerHour
    };

}
ParkingSpace copyWith({int? id, String? adress, double? pricePerHour}) {
    return ParkingSpace(
      id: id ?? this._id,
      adress: adress ?? this._adress,
      pricePerHour: pricePerHour ?? this._pricePerHour,
    );
  
  }
  factory ParkingSpace.fromMap(Map<String, dynamic> map) {
  return ParkingSpace(
    id: map['id'] as int,
    adress: map['adress'] as String,
    pricePerHour: map['pricePerHour'] as double,
  );
}

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'adress': adress,
    'pricePerHour': pricePerHour,
  };
}

@override
String toString(){
  return'ParkingSpace{id: $_id}, adress: $_adress, pricePerHour: $_pricePerHour}';
}

}
