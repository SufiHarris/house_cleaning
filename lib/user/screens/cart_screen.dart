import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/widgets/booking_card_cart.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';

class CartPage extends StatelessWidget {
  final UserProvider userProvider = Get.find<UserProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('My Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (userProvider.cartBookings.isEmpty) {
          return Center(child: Text('Your cart is empty'));
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Items (${userProvider.cartBookings.length})',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement remove items functionality
                      // userProvider.removeFromCart();
                      userProvider.clearCart();
                    },
                    child: Text('Remove Items',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userProvider.cartBookings.length,
                itemBuilder: (context, index) {
                  final booking = userProvider.cartBookings[index];
                  return Column(
                    children: [BookingCardCart(booking: booking), Divider()],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement continue shopping functionality
                    },
                    child: Text('Continue Shopping'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: CustomColors.primaryColor,
                      minimumSize: Size(double.infinity, 50),
                      side: BorderSide(color: CustomColors.primaryColor),
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          userProvider.processCartBookings();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${userProvider.calculateTotalCartPrice().toStringAsFixed(2)} SAR'),
                            Row(
                              children: [
                                Text('Checkout'),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
