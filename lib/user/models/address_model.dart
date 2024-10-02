class AddressModel {
  final String city;
  final String building;
  final String floor;
  final String landmark;
  final String name;
  final int user_id; // Renaming to camelCase for consistency

  AddressModel({
    required this.city,
    this.building = '',
    this.floor = '',
    this.landmark = '',
    required this.name,
    required this.user_id,
  });

  // From JSON (Firestore document)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'], // Assuming 'city' key holds the address field
      building: json['building'],
      floor: json['floor'],
      landmark: json['landmark'],
      name: json['name'],
      user_id: json['user_id'],
    );
  }

  // To JSON (if needed for database interaction)
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'building': building,
      'floor': floor,
      'landmark': landmark,
      'name': name,
      'user_id': user_id,
    };
  }
}

List<AddressModel> addressList = [];
