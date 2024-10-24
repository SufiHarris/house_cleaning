import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';
import 'package:house_cleaning/user/screens/user_main.dart';
import '../../auth/model/usermodel.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';

class CallBookingAddress extends StatefulWidget {
  final CategoryModel category;
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isStartTimeAM;
  final bool isEndTimeAM;

  const CallBookingAddress({
    Key? key,
    required this.category,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.isStartTimeAM,
    required this.isEndTimeAM,
  }) : super(key: key);

  @override
  State<CallBookingAddress> createState() => _CallBookingAddressState();
}

class _CallBookingAddressState extends State<CallBookingAddress> {
  final userProvider = Get.find<UserProvider>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userProvider.fetchAddresses();
    userProvider.getUserAddresses();
  }

  TimeOfDay _adjustTimeForAMPM(TimeOfDay time, bool isAM) {
    if (isAM && time.hour >= 12) {
      return TimeOfDay(hour: time.hour - 12, minute: time.minute);
    } else if (!isAM && time.hour < 12) {
      return TimeOfDay(hour: time.hour + 12, minute: time.minute);
    }
    return time;
  }

  Future<void> _handleBooking() async {
    if (userProvider.selectedAddress.value == null) {
      Get.snackbar(
        'Error',
        'Please select an address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      final adjustedStartTime =
          _adjustTimeForAMPM(widget.startTime, widget.isStartTimeAM);
      final adjustedEndTime =
          _adjustTimeForAMPM(widget.endTime, widget.isEndTimeAM);

      await userProvider.addCallBooking(
        address: userProvider.selectedAddress.value!.location ?? '',
        bookingDate: widget.selectedDate,
        startTime: adjustedStartTime,
        endTime: adjustedEndTime,
        category: widget.category,
        addressModel: userProvider.selectedAddress.value!,
        userPhoneNumber: '',
      );

      Get.snackbar(
        'Success',
        'Service booked successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => UserMain());
    } catch (e) {
      print('Error booking service: $e');
      Get.snackbar(
        'Error',
        'Failed to book service. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userProvider.addresses.isEmpty)
                const Center(child: Text('No addresses found.'))
              else if (userProvider.isLoading.value)
                const Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.addresses.length,
                    itemBuilder: (context, index) {
                      final address = userProvider.addresses[index];
                      return Column(
                        children: [
                          RadioListTile<AddressModel>(
                            value: address,
                            groupValue: userProvider.selectedAddress.value,
                            onChanged: (AddressModel? selectedAddress) {
                              if (selectedAddress != null) {
                                userProvider
                                    .setSelectedAddress(selectedAddress);
                              }
                            },
                            title: Text(
                              address.landmark,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${address.landmark}, ${address.building}, ${address.floor}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            secondary: const Icon(Icons.location_on),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => UserAddAddressPage()),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200, // Set a fixed width for the button
                  child: ElevatedButton(
                    onPressed:
                        isLoading || userProvider.selectedAddress.value == null
                            ? null
                            : _handleBooking,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      isLoading ? 'Booking...' : 'Book Service',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
