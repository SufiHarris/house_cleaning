import 'package:flutter/material.dart';
import 'package:house_cleaning/user/models/booking_model.dart';

class BookingWidget extends StatelessWidget {
  final Booking booking;
  const BookingWidget({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300, // You can change the color as needed
          width: 1, // Set the border width
        ),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.zero, // Remove margin from the card
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.id,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: booking.status == 'Pending'
                          ? Colors.orange
                          : booking.status == 'Completed'
                              ? Colors.green
                              : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Service Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(booking.serviceDate),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(booking.location),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Riyadh, Saudi Arabia'),
                  Text('\$${booking.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
