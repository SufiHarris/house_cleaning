import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';

import '../provider/admin_provider.dart';

class AssignEmployeeSheet extends StatelessWidget {
  final BookingModel booking;
  final ScrollController scrollController;
  final AdminProvider adminProvider;

  const AssignEmployeeSheet({
    Key? key,
    required this.booking,
    required this.scrollController,
    required this.adminProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImageOrIcon(booking),
                  ),
                  SizedBox(
                    width: 10,
                  ),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          booking.services.isEmpty
                              ? '${booking.products.length.toString()} rooms'
                              : '${booking.services.length.toString()} rooms',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${booking.total_price.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'SAR',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              HeadingText(headingText: 'Assign Employee'),
              Expanded(
                child: Obx(() {
                  print("Rebuilding AssignEmployeeSheet");
                  print(
                      "Number of employees: ${adminProvider.employees.length}");

                  if (adminProvider.employees.isEmpty) {
                    return Center(child: Text('No employees available'));
                  } else {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: adminProvider.employees.length,
                      itemBuilder: (context, index) {
                        final employee = adminProvider.employees[index];
                        print(
                            "Building ListTile for employee: ${employee.name}");
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      employee.image,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Container(
                                            width: 30,
                                            height: 30,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 30,
                                          height: 30,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    employee.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
        // Fixed "Assign" button at the bottom
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              // Add your logic to assign an employee
              print("Assign button clicked");
            },
            child: Text('Assign'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildImageOrIcon(BookingModel booking) {
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
