import 'package:flutter/material.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import '../../theme/custom_colors.dart';

class EmployeeBookingCard extends StatelessWidget {
  final BookingModel booking;
  const EmployeeBookingCard({Key? key, required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //   ),
        // ],
      ),
      child: booking.services.isEmpty
          ? _buildProductCard(context)
          : _buildServiceCard(context),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    final product = booking.products.first;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl,
            width: 40,
            height: 40,
            //fit: BoxFi,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.product_name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: CustomColors.textColorTwo)),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${booking.bookingTime}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CustomColors.textColorFive),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       '${product.price}',
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyLarge
              //           ?.copyWith(color: CustomColors.textColorFive),
              //     ),
              //     const SizedBox(
              //       width: 5,
              //     ),
              //     Text(
              //       'SAR',
              //       style: Theme.of(context).textTheme.labelSmall?.copyWith(
              //             color: CustomColors.textColorTwo,
              //           ),
              //     ),
              //     Spacer(),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                booking.categoryImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(booking.categoryName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: CustomColors.textColorTwo)),
                  //  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${booking.bookingTime}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: CustomColors.textColorFive),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
