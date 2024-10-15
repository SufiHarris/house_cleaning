import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/tracking/admin_tracking.dart';
import 'package:house_cleaning/tracking/client_tracking_map.dart';
import 'package:intl/intl.dart';

import '../../user/models/bookings_model.dart';
import 'assign_employee_sheet.dart';

class AdminBookingCard extends StatelessWidget {
  final AdminProvider adminProvider;
  final BookingModel booking;

  const AdminBookingCard(
      {Key? key, required this.booking, required this.adminProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImageOrIcon(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.services.isEmpty
                          ? booking.products[0].product_name
                          : booking.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      booking.services.isEmpty
                          ? booking.products.length.toString()
                          : booking.services.length.toString(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Text(
                booking.total_price.toString(),
              ),
              Text(
                ' SAR',
              ),
            ],
          ),
          Divider(
            height: 20,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Start time'), Text(booking.bookingTime)],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status'),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: _getStatusColor(booking.status),
                      ),
                      SizedBox(width: 5),
                      Text(
                        booking.status,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildButtons(context, booking, adminProvider),
        ],
      ),
    );
  }

  Widget _buildImageOrIcon() {
    String imageUrl = booking.services.isEmpty
        ? booking.products[0].imageUrl
        : booking.categoryImage;

    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackIcon();
            },
          )
        : _buildFallbackIcon();
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
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.yellow;
    case 'in progress':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.black;
  }
}

Widget _buildButtons(
    BuildContext context, BookingModel booking, AdminProvider adminProvider) {
  Widget buttonContent;

  switch (booking.status.toLowerCase()) {
    case 'unassigned':
      if (['fascade cleaning', 'villa cleaning', 'furniture cleaning']
          .contains(booking.categoryName.toLowerCase())) {
        buttonContent = Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleCall(context, booking),
                child: Text('Call'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.callButtonBg.withOpacity(0.2),
                    foregroundColor: CustomColors.callButton),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleAssign(context, booking, adminProvider),
                child: Text('Assign'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    foregroundColor: Colors.white),
              ),
            ),
          ],
        );
      } else {
        buttonContent = ElevatedButton(
          onPressed: () => _handleAssign(context, booking, adminProvider),
          child: Text('Assign'),
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              foregroundColor: Colors.white),
        );
      }
      break;
    case 'assigned':
    case 'pending':
      buttonContent = ElevatedButton(
        onPressed: () => _handleShowDetails(context, booking),
        child: Text('Show Details'),
        style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primaryColor,
            foregroundColor: Colors.white),
      );
      break;
    case 'inprogress':
      buttonContent = ElevatedButton(
        onPressed: () => _handleTrack(context, booking),
        child: Text('Track'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      );
      break;
    case 'working':
    case 'completed':
      buttonContent = ElevatedButton(
        onPressed: () => _handleShowDetails(context, booking),
        child: Text('Show Details'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
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

void _handleCall(BuildContext context, BookingModel booking) {
  print('Calling for booking ${booking.booking_id}');
}

void _handleAssign(
    BuildContext context, BookingModel booking, AdminProvider adminProvider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
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
  print('Showing details for booking ${booking.booking_id}');
}

void _handleTrack(BuildContext context, BookingModel booking) {
  Get.to(ClientTrackingMap());
  print('Tracking booking ${booking.booking_id}');
}
