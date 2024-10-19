import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/tracking/tracking_controller.dart';
import 'package:intl/intl.dart';
import '../../general_functions/booking_status.dart';
import '../../generated/l10n.dart';
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
                      S.of(context).dueDate,
                      DateFormat('EEEE d MMM')
                          .format(DateTime.parse(booking.bookingDate)),
                    ),
                    const SizedBox(width: 16),
                    _buildInfoItem(
                      Icons.access_time,
                      S.of(context).startTime,
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
                    child: Text(S.of(context).startService),
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
          S.of(context).clientAddress,
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
                    S.of(context).landmark,
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
                    S.of(context).contact,
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
          S.of(context).entryInstructions,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: CustomColors.textColorTwo),
        ),
        Text(
          S.of(context).entryInstructionsDetail,
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
          S.of(context).services,
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
            S.of(context).noServices,
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
                  '${S.of(context).size}: ${service.size}',
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
          S.of(context).products,
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
            S.of(context).noProducts,
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
                  '${S.of(context).delivery}: ${product.delivery_time}',
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
          S.of(context).makeSureToPick,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(S.of(context).mop),
            _buildChip(S.of(context).broom),
            _buildChip(S.of(context).standingLadder),
            _buildChip(S.of(context).cleaningLiquid),
            _buildChip(S.of(context).cloth),
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
