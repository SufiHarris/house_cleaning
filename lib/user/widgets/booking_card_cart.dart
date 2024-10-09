import 'package:flutter/material.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import '../../theme/custom_colors.dart';

class BookingCardCart extends StatelessWidget {
  final BookingModel booking;
  const BookingCardCart({Key? key, required this.booking}) : super(key: key);

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
            width: 80,
            height: 80,
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
                    '${product.price}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CustomColors.textColorFive),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'SAR',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: CustomColors.textColorTwo,
                        ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.remove, color: Colors.grey),
                            Text(
                              '${product.quantity}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.add, color: CustomColors.primaryColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
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
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.categoryName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: CustomColors.textColorTwo)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${booking.total_price}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: CustomColors.textColorFive),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'SAR',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: CustomColors.textColorTwo,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 80, // Adjust this height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: booking.services.length,
            itemBuilder: (context, index) {
              final service = booking.services[index];
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: serviceCard(service.service_name, service.quantity,
                    service.price, service.size, context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget serviceCard(
      String name, int quantity, double price, int size, BuildContext context) {
    return Container(
      width: 180, // Adjust this width as needed
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            maxLines: 1,
            '$name X $quantity',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CustomColors.textColorTwo,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                '\$$price ',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: CustomColors.textColorTwo,
                    ),
              ),
              Text(
                '| ${size} Sq/ft',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: CustomColors.textColorTwo,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
