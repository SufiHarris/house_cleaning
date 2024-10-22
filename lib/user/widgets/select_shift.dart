import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../auth/model/staff_model.dart';
import '../../theme/custom_colors.dart';
import '../models/bookings_model.dart';
import '../providers/user_provider.dart'; // Add intl package for date formatting
// Import your custom color file here

class ShiftSelectionWidget extends StatefulWidget {
  @override
  _ShiftSelectionWidgetState createState() => _ShiftSelectionWidgetState();
}

class _ShiftSelectionWidgetState extends State<ShiftSelectionWidget> {
  DateTime? selectedDate;
  String? selectedShift;
  List<String> availableShifts = [];
  List<StaffModel> allEmployees =
      []; // Assuming you fetch this from the provider
  List<BookingModel> bookings = []; // Assuming you fetch this from the provider
  final userProvider = Get.find<UserProvider>();

  @override
  void initState() {
    super.initState();
    // Initialize available employees and bookings from userProvider (Assumed)
    allEmployees = userProvider.allEmployees;
    bookings = userProvider.bookings;
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Date",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: CalendarDatePicker(
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                    });
                    _updateAvailableShifts(selectedDate!);
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDateButton("Today", () {
                      setState(() {
                        selectedDate = DateTime.now();
                      });
                      _updateAvailableShifts(selectedDate!);
                      Navigator.pop(context);
                    }),
                    _buildDateButton("Tomorrow", () {
                      setState(() {
                        selectedDate =
                            DateTime.now().add(const Duration(days: 1));
                      });
                      _updateAvailableShifts(selectedDate!);
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateAvailableShifts(DateTime selectedDate) {
    // Reset available shifts
    availableShifts = [];

    // Filter bookings for the selected date
    List<BookingModel> todaysBookings = bookings
        .where((booking) =>
            booking.bookingDate ==
            DateFormat('yyyy-MM-dd').format(selectedDate))
        .toList();

    // Get employees booked for morning and afternoon shifts
    Set<String> morningEmployees = {};
    Set<String> afternoonEmployees = {};

    for (var booking in todaysBookings) {
      if (booking.shift_names.contains("Morning")) {
        morningEmployees.addAll(booking.employee_ids);
      }
      if (booking.shift_names.contains("Afternoon")) {
        afternoonEmployees.addAll(booking.employee_ids);
      }
    }

    // Check if there are available employees for the morning shift
    if (allEmployees
        .any((employee) => !morningEmployees.contains(employee.employeeId))) {
      availableShifts.add("Morning");
    }

    // Check if there are available employees for the afternoon shift
    if (allEmployees
        .any((employee) => !afternoonEmployees.contains(employee.employeeId))) {
      availableShifts.add("Afternoon");
    }

    // If no shifts are available, show a message
    if (availableShifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No employees available on this date.")),
      );
    }

    // Update the UI
    setState(() {});
  }

  Widget _buildShiftSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Shift",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CustomColors.textColorTwo,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildShiftChip("Morning", availableShifts.contains("Morning")),
            _buildShiftChip("Afternoon", availableShifts.contains("Afternoon")),
          ],
        ),
      ],
    );
  }

  Widget _buildShiftChip(String shift, bool isAvailable) {
    return FilterChip(
      label: Text(shift),
      selected: selectedShift == shift,
      onSelected: isAvailable
          ? (bool selected) {
              setState(() {
                selectedShift = selected ? shift : null;
              });
            }
          : null,
      backgroundColor: isAvailable ? Colors.grey[200] : Colors.grey[400],
      selectedColor: CustomColors.primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isAvailable ? Colors.black : Colors.grey[600],
      ),
    );
  }

  Widget _buildDateButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShiftSelection(),
        ElevatedButton(
          onPressed: () => _showDatePicker(context),
          child: Text("Select Date"),
        ),
      ],
    );
  }
}
