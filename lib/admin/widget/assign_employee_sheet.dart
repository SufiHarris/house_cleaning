import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';

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
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign Employee',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              print("Rebuilding AssignEmployeeSheet");
              print("Number of employees: ${adminProvider.employees.length}");

              if (adminProvider.employees.isEmpty) {
                return Center(child: Text('No employees available'));
              } else {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: adminProvider.employees.length,
                  itemBuilder: (context, index) {
                    final employee = adminProvider.employees[index];
                    print("Building ListTile for employee: ${employee.name}");
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(employee.name[0]),
                      ),
                      title: Text(employee.name),
                      subtitle: Text(employee.role),
                      onTap: () {
                        print(
                            'Selected employee: ${employee.name} for booking ${booking.booking_id}');
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
