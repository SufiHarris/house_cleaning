import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';
import '../provider/admin_provider.dart';

class AssignEmployeeSheet extends StatefulWidget {
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
  State<AssignEmployeeSheet> createState() => _AssignEmployeeSheetState();
}

class _AssignEmployeeSheetState extends State<AssignEmployeeSheet> {
  final Set<String> selectedEmployeeIds = {};
  List<StaffModel> availableEmployees = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableEmployees();
  }

  void _loadAvailableEmployees() {
    // Get booking date
    DateTime bookingDate = DateTime.parse(widget.booking.bookingDate);
    String bookingDateStr = DateFormat('yyyy-MM-dd').format(bookingDate);

    // Get all employees and bookings for that date
    List<StaffModel> allEmployees = widget.adminProvider.employees;
    List<BookingModel> bookings = widget.adminProvider.bookings;

    // Get bookings for the same date
    List<BookingModel> datewiseBookings = bookings.where((booking) {
      DateTime date = DateTime.parse(booking.bookingDate);
      String dateStr = DateFormat('yyyy-MM-dd').format(date);
      return dateStr == bookingDateStr;
    }).toList();

    // Get busy employee IDs for each shift
    Set<String> busyEmployeeIds = {};

    for (var booking in datewiseBookings) {
      // Check if shifts overlap
      bool shiftsOverlap = false;
      for (var bookingShift in booking.shift_names) {
        if (widget.booking.shift_names.contains(bookingShift)) {
          shiftsOverlap = true;
          break;
        }
      }

      if (shiftsOverlap) {
        busyEmployeeIds.addAll(booking.employee_ids);
      }
    }

    // Filter available employees
    setState(() {
      availableEmployees = allEmployees
          .where((employee) => !busyEmployeeIds.contains(employee.employeeId))
          .toList();
    });
  }

  void _toggleEmployeeSelection(String employeeId) {
    setState(() {
      if (selectedEmployeeIds.contains(employeeId)) {
        selectedEmployeeIds.remove(employeeId);
      } else {
        selectedEmployeeIds.add(employeeId);
      }
    });
  }

  Future<void> _assignEmployees() async {
    if (selectedEmployeeIds.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one employee',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Print full booking object
      print("=== FULL BOOKING DETAILS ===");
      print("Booking ID: ${widget.booking.booking_id}");
      print("Category Name: ${widget.booking.categoryName}");
      print("Booking Date: ${widget.booking.bookingDate}");
      print("Services: ${widget.booking.services}");
      print("Products: ${widget.booking.products}");
      print("Shift Names: ${widget.booking.shift_names}");
      print("Employee IDs: ${widget.booking.employee_ids}");
      print("Category Image: ${widget.booking.categoryImage}");
      print("========================");

      await widget.adminProvider.assignEmployeesToBooking(
        widget.booking.booking_id.toString(),
        selectedEmployeeIds.toList(),
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Employees assigned successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to assign employees: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
              // Booking details section (unchanged)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImageOrIcon(widget.booking),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.booking.services.isEmpty
                              ? widget.booking.products[0].product_name
                              : widget.booking.categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Shifts: ${widget.booking.shift_names.join(", ")}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              HeadingText(
                  headingText:
                      'Available Employees (${availableEmployees.length})'),
              Expanded(
                child: availableEmployees.isEmpty
                    ? Center(
                        child: Text('No available employees for this shift'))
                    : ListView.builder(
                        controller: widget.scrollController,
                        itemCount: availableEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = availableEmployees[index];
                          final isSelected =
                              selectedEmployeeIds.contains(employee.employeeId);

                          return ListTile(
                            leading: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    employee.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.person),
                                      );
                                    },
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(employee.name),
                            subtitle: Text(
                              'ID: ${employee.employeeId}',
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            tileColor: isSelected
                                ? Colors.blue[50]
                                : Colors.transparent,
                            onTap: () =>
                                _toggleEmployeeSelection(employee.employeeId),
                          );
                        },
                      ),
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
            onPressed: _assignEmployees,
            child: Text(
                'Assign ${selectedEmployeeIds.isEmpty ? "" : "(${selectedEmployeeIds.length} selected)"}'),
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
