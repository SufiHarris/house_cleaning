import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../user/models/bookings_model.dart';

class AdminBookingCard extends StatelessWidget {
  final BookingModel booking;

  const AdminBookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                booking.services.isEmpty
                    ? booking.products[0].imageUrl
                    : booking.categoryImage,
                width: 50,
                height: 50,
              ),
            ),
            Column(
              children: [
                Text(
                  booking.services.isEmpty
                      ? booking.categoryName
                      : booking.products[0].product_name,
                ),
                Text(
                  booking.services.isEmpty
                      ? booking.services.length.toString()
                      : booking.products.length.toString(),
                )
              ],
            )
          ],
        )
      ]),
    );
  }
}
