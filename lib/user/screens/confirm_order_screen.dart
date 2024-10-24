import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/auth/screens/fast_register.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';
import 'package:house_cleaning/user/screens/user_select_address.dart';
import 'package:house_cleaning/user/widgets/confirm_order_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

import 'user_main.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  String? userId; // Store userId here

  @override
  void initState() {
    super.initState();
    _getUserIdFromPrefs();
  }

  Future<void> _getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs
          .getString('userDocId'); // Retrieve userId from SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();
    final authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Order"),
      ),
      body: Obx(() {
        double totalPrice = userProvider.selectedServices
            .fold(0, (sum, service) => sum + service.totalPrice);
        totalPrice += userProvider.selectedProducts
            .fold(0, (sum, product) => sum + product.price);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageSection(
                    context, totalPrice, userProvider.imageString.toString()),
                const Divider(height: 32),
                _buildBookingDetails(context, userProvider),
                const Divider(height: 32),
                _buildAddressSection(context, userProvider),
                const Divider(height: 32),
                _buildServiceSummary(context, userProvider),
                const Divider(height: 32),
                _buildProductsList(context, userProvider),
                const Divider(height: 32),
                // _buildTotalPrice(context, totalPrice),
                // const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("User ID from SharedPreferences: $userId");

                    // Check if userId exists from SharedPreferences
                    if (userId == null || userId!.isEmpty) {
                      // User is not logged in, navigate to FastRegister
                      Get.to(() => FastRegister(
                          isCartAction: true)); // Pass a flag for add to cart
                    } else {
                      // User is logged in, add items to cart
                      userProvider.addToCart();
                    }
                  },
                  child: Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    // Check if userId exists from SharedPreferences
                    if (userId == null || userId!.isEmpty) {
                      // User is not logged in, navigate to FastRegister
                      Get.to(() => FastRegister(
                          isCartAction: false)); // Pass a flag for add to cart
                    } else {
                      print(userProvider.selectedServices.value);
                      // User is logged in, proceed to save booking
                      userProvider.saveBookingToFirestore();
                    }
                  },
                  child: Text('Confirm Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _imageSection(
      BuildContext context, double totalPrice, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100, // Set fixed height for the image
                width: 100, // Set fixed width for the image

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit
                        .cover, // Make sure the image covers the container
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Center(child: Text('Failed to load image'));
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Home Cleaning",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColors.textColorTwo,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text("Total Price",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: CustomColors.textColorTwo)),
                  Text(
                    "\$${totalPrice}",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: CustomColors.textColorThree,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSummary(BuildContext context, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Services",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        ...userProvider.selectedServices.map((service) => ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(service.serviceName),
              subtitle: Text(
                  "Quantity: ${service.totalQuantity}, Size: ${service.totalSize}"),
              trailing: Text("\$${service.totalPrice.toStringAsFixed(2)}"),
            )),
      ],
    );
  }

  Widget _buildBookingDetails(BuildContext context, UserProvider userProvider) {
    DateTime? selectedDate = userProvider.selectedDate.value;

    // If the selected date is not null, format the date and time
    String formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate) // e.g., 2024-10-03
        : 'Not selected';
    String formattedDay = selectedDate != null
        ? DateFormat('EEEE').format(selectedDate) // e.g., Thursday
        : 'Not selected';
    String formattedTime = selectedDate != null
        ? DateFormat('hh:mm a').format(selectedDate) // e.g., 02:30 PM
        : 'Not selected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfirmOrderEdit(
            title: "Bookings",
            onClick: () {
              Get.to(UserSelectAddress());
            }),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Day / Date"),
            Text(
                "${formattedDay} - ${formattedDate} "), // Display formatted date
          ],
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Time"),
            Text(formattedTime), // Display formatted time
          ],
        ),
      ],
    );
  }

  Widget _buildProductsList(BuildContext context, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Products",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        ...userProvider.selectedProducts.map((product) => ListTile(
              leading: Image.network(product.imageUrl, width: 50, height: 50),
              title: Text(product.name),
              trailing: Text("\$${product.price.toStringAsFixed(2)}"),
            )),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context, UserProvider userProvider) {
    final address = userProvider.selectedAddress.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfirmOrderEdit(
            title: "Address",
            onClick: () {
              Get.to(UserSelectAddress());
            }),
        const SizedBox(height: 10),
        if (address != null)
          Text(" ${address.building}, ${address.floor}, ${address.landmark}")
        else
          TextButton(
            onPressed: () {
              // Implement address selection logic
            },
            child: const Text("Select Address"),
          ),
      ],
    );
  }

  // Widget _buildTotalPrice(BuildContext context, double totalPrice) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         "Total Price",
  //         style: Theme.of(context).textTheme.bodyLarge,
  //       ),
  //       Text(
  //         "\$${totalPrice.toStringAsFixed(2)}",
  //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //               color: CustomColors.textColorThree,
  //               fontWeight: FontWeight.w600,
  //             ),
  //       ),
  //     ],
  //   );
  // }
}
