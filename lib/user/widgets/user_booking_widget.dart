import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import 'package:house_cleaning/user/screens/user_bookings_detail_page.dart';
import 'package:house_cleaning/tracking/client_tracking_map.dart';
import '../../theme/custom_colors.dart';

class UserBookingWidget extends StatelessWidget {
  final BookingModel booking;
  // ignore: use_super_parameters
  const UserBookingWidget({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          booking.services.isEmpty
              ? _buildProductCard(context)
              : _buildServiceCard(context),
          SizedBox(height: 16),
          _buildButtons(context, booking),
        ],
      ),
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
                  const SizedBox(width: 5),
                  Text(
                    'SAR',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: CustomColors.textColorTwo,
                        ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                      const SizedBox(width: 5),
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
          height: 80,
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
      width: 180,
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

  Widget _buildButtons(BuildContext context, BookingModel booking) {
    Widget buttonContent;

    final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
    );

    switch (booking.status.toLowerCase()) {
      case 'unassigned':
      case 'assigned':
      case 'pending':
      case 'working':
      case 'completed':
        buttonContent = ElevatedButton(
          onPressed: () => _handleShowDetails(context, booking),
          child: Text('Show Details'),
          style: commonButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
                booking.status.toLowerCase() == 'completed'
                    ? Colors.teal
                    : CustomColors.primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        );
        break;
      case 'inprogress':
        buttonContent = ElevatedButton(
          onPressed: () => _handleTrack(context, booking),
          child: Text('Track'),
          style: commonButtonStyle.copyWith(
            backgroundColor:
                MaterialStateProperty.all(CustomColors.trackButtonBg),
            foregroundColor:
                MaterialStateProperty.all(CustomColors.trackButton),
          ),
        );
        break;
      default:
        buttonContent = SizedBox();
    }

    return SizedBox(
      width: double.infinity,
      child: buttonContent,
    );
  }

  void _handleShowDetails(BuildContext context, BookingModel booking) {
    Get.to(() => UserBookingDetailsPage(booking: booking));
  }

  void _handleTrack(BuildContext context, BookingModel booking) {
    Get.to(() => ClientTrackingMap());
  }
}
