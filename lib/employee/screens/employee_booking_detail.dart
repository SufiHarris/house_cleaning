import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/tracking/tracking_controller.dart';
import 'package:intl/intl.dart';
import '../../general_functions/booking_status.dart';
import '../../tracking/google_map_widget.dart';
import '../../user/models/bookings_model.dart';

class EmployeeBookingDetail extends StatelessWidget {
  final BookingModel booking;

  final BookingController bookingController = Get.put(BookingController());

  EmployeeBookingDetail({super.key, required this.booking});
  // final String bookingId;

  // BookingPage({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final employeeTrackingController = Get.find<EmployeeTrackingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(booking.categoryName != ''
            ? booking.categoryName
            : 'Product Booking'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoItem(
                      Icons.calendar_today,
                      'Due Date',
                      DateFormat('EEEE d MMM')
                          .format(DateTime.parse(booking.bookingDate)),
                    ),
                    const SizedBox(width: 16),
                    _buildInfoItem(
                      Icons.access_time,
                      'Start Time',
                      booking.bookingTime,
                    ),
                  ],
                ),
                _buildSectionDivider(),
                _buildAddressSection(context),
                _buildSectionDivider(),
                _buildEntryInstructions(context),
                _buildSectionDivider(),
                _buildServicesSection(context),
                _buildSectionDivider(),
                _buildProductsSection(context),
                _buildSectionDivider(),
                _buildItemsToPickSection(context),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // employeeTrackingController.startTracking();
                      bookingController.updateBookingStatus(
                          booking.booking_id.toString(), 'inprogress');

                      // Navigate to the EmployeeTrackingMap with lat and lng
                      Get.to(() => EmployeeTrackingMap(
                            booking: booking,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: CustomColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start Service'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return const Column(
      children: [
        SizedBox(height: 8),
        Divider(),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Client Address',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        Text(
          booking.address,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Landmark',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CustomColors.textColorTwo),
                  ),
                  Text(
                    booking.landmark,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: CustomColors.textColorTwo),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CustomColors.textColorTwo),
                  ),
                  Text(
                    booking.user_phn_number,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: CustomColors.textColorTwo),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEntryInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entry Instructions',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        Text(
          'Wait outside the gate facing the camera and call me directly.',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context) {
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

  Widget _buildItemsToPickSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Make sure to pick',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip('Mop'),
            _buildChip('Broom'),
            _buildChip('Standing Ladder'),
            _buildChip('Cleaning Liquid'),
            _buildChip('Cloth'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
    );
  }
}
