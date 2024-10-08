import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'controller/user_addaddress_controller.dart';

class SelectLocationOnMapPage extends StatefulWidget {
  @override
  _SelectLocationOnMapPageState createState() =>
      _SelectLocationOnMapPageState();
}

class _SelectLocationOnMapPageState extends State<SelectLocationOnMapPage> {
  LatLng? selectedLocation;
  Set<Marker> markers = {};
  late GoogleMapController _mapController;
  final AddAddressController addAddressController =
      Get.find<AddAddressController>();

  // Define the boundaries for Riyadh
  final LatLngBounds riyadhBounds = LatLngBounds(
    southwest: LatLng(24.6352, 46.6022), // Southwest corner
    northeast: LatLng(24.8594, 46.8349), // Northeast corner
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: TextStyle(color: CustomColors.textColorThree),
        ),
        backgroundColor: CustomColors.eggPlant,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(24.7136, 46.6753), // Riyadh coordinates
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: markers,
            onTap: (LatLng location) {
              if (_isLocationInRiyadh(location)) {
                setState(() {
                  selectedLocation = location;
                  markers = {
                    Marker(
                      markerId: MarkerId('selected-location'),
                      position: selectedLocation!,
                    ),
                  };

                  _mapController.animateCamera(
                    CameraUpdate.newLatLng(selectedLocation!),
                  );
                });
              } else {
                Get.snackbar(
                  'Location Outside Riyadh',
                  'Please select a location within Riyadh.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: CustomColors.textColorThree,
                  colorText: Colors.white,
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                onPressed: () {
                  if (selectedLocation != null) {
                    Get.back(result: selectedLocation);
                  } else {
                    Get.snackbar(
                      "Error",
                      "No location selected. Please select a location within Riyadh.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Icon(Icons.check),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _useCurrentLocation,
                child: Icon(Icons.my_location),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    try {
      await addAddressController.useCurrentLocation();
      if (addAddressController.currentLocation.value != null) {
        LatLng currentPosition = addAddressController.currentLocation.value!;
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition, 14.0),
        );

        setState(() {
          selectedLocation = currentPosition;
          markers = {
            Marker(
              markerId: MarkerId('current-location'),
              position: currentPosition,
            ),
          };
        });
      }
    } catch (e) {
      print('Error using current location: $e');
      Get.snackbar("Error", "Failed to get the current location.");
    }
  }

  bool _isLocationInRiyadh(LatLng location) {
    return riyadhBounds.contains(location);
  }
}
