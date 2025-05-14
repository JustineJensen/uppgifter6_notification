enum VehicleType {
  Bil,
  Motorcycle,
  Lastbil,

}

extension VehicleTypeExtension on VehicleType {
  String toJson() {
    return this.name;
  }

  static VehicleType fromJson(dynamic json) {
    try {
      if (json is int) {
        switch (json) {
          case 1:
            return VehicleType.Bil;
          case 2:
            return VehicleType.Lastbil;
          case 3:
            return VehicleType.Motorcycle;
          default:
            throw ArgumentError('Unknown VehicleType number: $json');
        }
      } else if (json is String) {
        json = json.toLowerCase().replaceAll('vehicletype.', '');
        if (json == 'car') {
          json = 'bil';  
        }

        return VehicleType.values.firstWhere(
          (e) => e.name.toLowerCase() == json,
        );
      }

      throw ArgumentError('Invalid VehicleType format: $json');
    } catch (e) {
      throw ArgumentError('Unknown VehicleType: $json');
    }
  }
}
