import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/admin/screeens/admin_booking_detail_page.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/tracking/client_tracking_map.dart';
import 'package:house_cleaning/user/screens/user_bookings_detail_page.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import 'assign_employee_sheet.dart';

class AdminBookingCard extends StatelessWidget {
  final AdminProvider adminProvider;
  final BookingModel booking;

  const AdminBookingCard(
      {Key? key, required this.booking, required this.adminProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('====== Booking Debug Info ======');
    print('Booking ID: ${booking.booking_id}');
    print('Services Length: ${booking.services.length}');
    print('Services: ${booking.services.map((s) => s.service_name).toList()}');
    print('Products Length: ${booking.products.length}');
    print('Products: ${booking.products.map((p) => p.product_name).toList()}');
    print('Category Name: ${booking.categoryName}');
    print('Category Image: ${booking.categoryImage}');
    print('=============================');
    // Check if booking has services or products
    final hasServices = booking.services.isNotEmpty;
    final hasProducts = booking.products.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImageOrIcon(hasServices, hasProducts),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDisplayName(hasServices, hasProducts),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getItemCount(hasServices, hasProducts),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CustomColors.textColorFive,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${booking.total_price.toStringAsFixed(2)} SAR',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CustomColors.primaryColor,
                    ),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildTimeAndStatus(context),
          const SizedBox(height: 10),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildImageOrIcon(bool hasServices, bool hasProducts) {
    String? imageUrl;

    if (hasServices) {
      // Use category image for service bookings
      imageUrl = booking.categoryImage;
    } else if (hasProducts && booking.products.first.imageUrl.isNotEmpty) {
      // Use first product image for product bookings
      imageUrl = booking.products.first.imageUrl;
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }
    return _buildFallbackIcon();
  }

  String _getDisplayName(bool hasServices, bool hasProducts) {
    if (hasServices) {
      return booking.categoryName;
    } else if (hasProducts) {
      return booking.products.first.product_name;
    }
    return 'Unknown Booking';
  }

  String _getItemCount(bool hasServices, bool hasProducts) {
    if (hasServices) {
      return '${booking.services.length} Service${booking.services.length > 1 ? 's' : ''}';
    } else if (hasProducts) {
      return '${booking.products.length} Product${booking.products.length > 1 ? 's' : ''}';
    }
    return 'No items';
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[300],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildTimeAndStatus(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start time',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: CustomColors.textColorFive,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              booking.bookingTime ?? 'Not set',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            )
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: CustomColors.textColorFive,
                  ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                CircleAvatar(
                  radius: 6,
                  backgroundColor: _getStatusColor(booking.status ?? 'unknown'),
                ),
                const SizedBox(width: 5),
                Text(
                  booking.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getStatusColor(booking.status ?? 'unknown'),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _buildButtons(context, booking, adminProvider),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'unassigned':
      return CustomColors.trackButton;
    case 'in progress':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Widget _buildButtons(
    BuildContext context, BookingModel booking, AdminProvider adminProvider) {
  final status = booking.status.toLowerCase();
  final hasSpecialServices = [
    'fascade cleaning',
    'villa cleaning',
    'furniture cleaning'
  ].contains(booking.categoryName.toLowerCase());

  // Define common button style
  final commonButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12),
  );

  if (status == 'unassigned' && hasSpecialServices) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleCall(context, booking),
            style: commonButtonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(
                CustomColors.callButtonBg.withOpacity(0.2),
              ),
              foregroundColor:
                  MaterialStateProperty.all(CustomColors.callButton),
            ),
            child: const Text('Call'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleAssign(context, booking, adminProvider),
            style: commonButtonStyle.copyWith(
              backgroundColor:
                  MaterialStateProperty.all(CustomColors.primaryColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: const Text('Assign'),
          ),
        ),
      ],
    );
  }

  // Single button cases
  Widget? singleButton;
  switch (status) {
    case 'unassigned':
      singleButton = ElevatedButton(
        onPressed: () => _handleAssign(context, booking, adminProvider),
        style: commonButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(CustomColors.primaryColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: const Text('Assign'),
      );
      break;
    case 'inprogress':
      singleButton = ElevatedButton(
        onPressed: () => _handleTrack(context, booking),
        style: commonButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.purple),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: const Text('Track'),
      );
      break;
    case 'completed':
    case 'assigned':
    case 'pending':
    case 'working':
      singleButton = ElevatedButton(
        onPressed: () => _handleShowDetails(context, booking),
        style: commonButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.teal),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: const Text('Show Details'),
      );
      break;
  }

  return singleButton ?? const SizedBox.shrink();
}

void _handleCall(BuildContext context, BookingModel booking) {
  // Implement call functionality
  print('Calling for booking ${booking.booking_id}');
}

void _handleAssign(
    BuildContext context, BookingModel booking, AdminProvider adminProvider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (_, scrollController) => AssignEmployeeSheet(
        booking: booking,
        scrollController: scrollController,
        adminProvider: adminProvider,
      ),
    ),
  );
}

void _handleShowDetails(BuildContext context, BookingModel booking) {
  Get.to(() => AdminBookingDetailPage(booking: booking));
}

void _handleTrack(BuildContext context, BookingModel booking) {
  Get.to(() => ClientTrackingMap());
}
