import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

import '../../user/models/bookings_model.dart';

class AdminBookingDetailPage extends StatelessWidget {
  final BookingModel booking;

  const AdminBookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final hasServices = booking.services.isNotEmpty;
    final hasProducts = booking.products.isNotEmpty;
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
              _buildProductHeader(context, hasProducts, hasProducts),
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
              OrderStatusTimeline(
                status: booking.status,
                beforeImage: booking.start_image.first,
                afterImage: booking.endImage.first,
              ),
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

  Widget _buildProductHeader(
      BuildContext context, bool hasServices, bool hasProducts) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            hasServices
                ? booking.categoryImage
                : booking.products.first.imageUrl,
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
                hasServices
                    ? booking.categoryName
                    : booking.products.first.product_name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: CustomColors.textColorTwo),
              ),
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      '${hasServices ? booking.total_price.toString() : booking.products.first.price} ',
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
  final String? beforeImage;
  final String? afterImage;

  const OrderStatusTimeline({
    Key? key,
    required this.status,
    this.beforeImage,
    this.afterImage,
  }) : super(key: key);

  bool isFirstStepActive() => true;

  bool isSecondStepActive() {
    return status == 'inprocess' ||
        status == 'working' ||
        status == 'completed' ||
        status == 'review';
  }

  bool isThirdStepActive() {
    return status == 'completed' || status == 'review';
  }

  bool shouldShowBeforeImage() {
    return status == 'working' ||
        status == 'inprocess' ||
        status == 'completed' ||
        status == 'review';
  }

  bool shouldShowAfterImage() {
    return status == 'completed' || status == 'review';
  }

  bool get hasAnyImage => beforeImage != null || afterImage != null;

  Widget _buildWaitingForImages() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            color: Colors.grey.shade400,
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            'Waiting for Images',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timeline Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildTimelineStep('Booked', isFirstStepActive()),
                          Expanded(
                            child: _buildTimelineConnector(
                                isFirstStepActive() && isSecondStepActive()),
                          ),
                          _buildTimelineStep('Started', isSecondStepActive()),
                          Expanded(
                            child: _buildTimelineConnector(
                                isSecondStepActive() && isThirdStepActive()),
                          ),
                          _buildTimelineStep('Completed', isThirdStepActive()),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child:
                                _buildStepLabel('Booked', isFirstStepActive()),
                          ),
                          Expanded(
                            child: _buildStepLabel(
                                'Started', isSecondStepActive()),
                          ),
                          Expanded(
                            child: _buildStepLabel(
                                'Completed', isThirdStepActive()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Images Section
        //  if (shouldShowBeforeImage() || shouldShowAfterImage())
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text(
              'Pictures',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            if (!hasAnyImage)
              _buildWaitingForImages()
            else
              Row(
                children: [
                  if (shouldShowBeforeImage())
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: beforeImage != null
                                  ? Image.network(
                                      beforeImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey.shade400,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Before',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (shouldShowBeforeImage() && shouldShowAfterImage())
                    SizedBox(width: 12),
                  if (shouldShowAfterImage())
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: afterImage != null
                                  ? Image.network(
                                      afterImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey.shade400,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'After',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
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
      height: 2,
      color: isActive ? CustomColors.primaryColor : Colors.grey.shade300,
    );
  }

  Widget _buildStepLabel(String label, bool isActive) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isActive ? CustomColors.primaryColor : Colors.grey.shade500,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
