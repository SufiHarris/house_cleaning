import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import '../models/bookings_model.dart';

class UserBookingDetailsPage extends StatelessWidget {
  final BookingModel booking;

  const UserBookingDetailsPage({Key? key, required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductHeader(context),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              _buildBookingInfo(context),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              _buildServicesSection(context, booking),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              _buildProductsSection(context),

              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              _buildAddress(context),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              OrderStatusTimeline(status: booking.status),
              //    _buildLiveTrackingButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        const SizedBox(height: 8),
        if (booking.products.isNotEmpty)
          ...booking.products
              .map((product) => _buildProductItem(context, product))
        else
          Text(
            'No products ordered',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: CustomColors.textColorTwo),
          ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, ProductBooking product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.product_name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Delivery: ${product.delivery_time}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.quantity}x',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            booking.products.first.imageUrl,
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
              Text(
                booking.products.first.product_name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: CustomColors.textColorTwo),
              ),
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${booking.products.first.price} ',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: CustomColors.textColorTwo)),
                  Text('SAR',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: CustomColors.textColorSix)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Day / Date',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: CustomColors.textColorTwo),
              ),
            ),
            Text(
              booking.bookingDate,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: CustomColors.textColorTwo),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        SizedBox(height: 8),
        Text(
          booking.address,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
      ],
    );
  }

  Widget _buildLiveTrackingButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implement live tracking functionality
        },
        child: Text('Live Tracking'),
        style: ElevatedButton.styleFrom(
          // primary: Color(0xFF6B2D5C),
          // onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

Widget _buildServicesSection(BuildContext context, BookingModel booking) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Services',
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: CustomColors.textColorTwo),
      ),
      const SizedBox(height: 8),
      if (booking.services.isNotEmpty)
        ...booking.services
            .map((service) => _buildServiceItem(context, service))
      else
        Text(
          'No services booked',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
    ],
  );
}

Widget _buildServiceItem(BuildContext context, ServiceBooking service) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.service_name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Size: ${service.size}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${service.quantity}x',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${service.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    ),
  );
}

class OrderStatusTimeline extends StatelessWidget {
  final String status;

  const OrderStatusTimeline({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Column(
              children: [
                _buildTimelineStep('Order Placed', true),
                _buildTimelineConnector(true),
                _buildTimelineStep('Left for delivery', status == 'In Process'),
                _buildTimelineConnector(false),
                _buildTimelineStep('Delivered', status == 'Delivered'),
              ],
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepLabel('Order Placed', true),
                SizedBox(height: 20),
                _buildStepLabel('Left for delivery', status == 'In Process'),
                SizedBox(height: 20),
                _buildStepLabel('Delivered', status == 'Delivered'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String step, bool isActive) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? CustomColors.primaryColor : Colors.white,
        border: Border.all(
          color: isActive ? CustomColors.primaryColor : Colors.grey.shade300,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildTimelineConnector(bool isActive) {
    return Container(
      width: 2,
      height: 30,
      color: isActive ? CustomColors.primaryColor : Colors.grey.shade300,
    );
  }

  Widget _buildStepLabel(String label, bool isActive) {
    return Text(
      label,
      style: TextStyle(
        color: isActive ? CustomColors.primaryColor : Colors.grey.shade500,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
