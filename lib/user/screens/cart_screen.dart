import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';

class CartPage extends StatelessWidget {
  final UserProvider userProvider = Get.find<UserProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Obx(() {
        if (userProvider.cartBookings.isEmpty) {
          return Center(
            child: Text('Your cart is empty'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userProvider.cartBookings.length,
                itemBuilder: (context, index) {
                  final booking = userProvider.cartBookings[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Date: ${booking.bookingDate}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Services:'),
                          ...booking.services.map((service) => Text(
                              '- ${service.service_name} (${service.quantity})')),
                          SizedBox(height: 8),
                          if (booking.products.isNotEmpty) ...[
                            Text('Products:'),
                            ...booking.products.map((product) => Text(
                                '- ${product.product_name} (${product.quantity})')),
                          ],
                          SizedBox(height: 8),
                          Text(
                            'Total Price: \$${booking.total_price}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  userProvider.processCartBookings();
                },
                child: Text('Confirm All Bookings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
