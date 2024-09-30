// address_model.dart
class AddressModel {
  final String addressTitle;
  final String address;

  AddressModel({
    required this.addressTitle,
    required this.address,
  });
}

final List<AddressModel> addressList = [
  AddressModel(
    addressTitle: "Home Address",
    address: "1234 Desert Oasis Street, Riyadh, Saudi Arabia, 12345",
  ),
  AddressModel(
    addressTitle: "Office Address",
    address: "5678 Business Bay, Riyadh, Saudi Arabia, 67890",
  ),
];
