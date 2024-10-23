import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/screens/edit_employee.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/employee/screens/add_employee_screen.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import '../provider/admin_provider.dart';

class EmployeeManagement extends StatelessWidget {
  const EmployeeManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Get.find<AdminProvider>();
    adminProvider.fetchEmployees();

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
      ),
      body: Column(
        children: [
          _buildTotalUsersCard(adminProvider),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Employee",
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.textfieldBorderColor, width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.textfieldBorderColor, width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Adds space between TextField and button
                GestureDetector(
                  onTap: () {
                    Get.to(AddEmployeeScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: CustomColors.eggPlant,
                          ),
                          Text(
                            'ADD',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: CustomColors.eggPlant,
                                    ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 16), // Space between Row and ListView.builder

          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: adminProvider.employees.length,
                  itemBuilder: (context, index) {
                    final employee = adminProvider.employees[index];
                    return _buildEmployeeCard(employee);
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalUsersCard(AdminProvider adminProvider) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.people, size: 24),
            SizedBox(width: 8),
            Text(
              'Total Employees',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Obx(() => Text(
                  '${adminProvider.employees.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(StaffModel employee) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      employee.image,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
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
                  SizedBox(width: 16),
                  Text(
                    employee.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => EditEmployeeScreen(
                          employee:
                              employee)); // Navigate to EditEmployeeScreen with employee data
                    },
                    child: Icon(
                      Icons.edit,
                      color: CustomColors.primaryColor,
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            _buildInfoRow(Icons.email, 'Status', 'Active'),
            Divider(),
            _buildInfoRow(Icons.email, 'Email', employee.email),
            Divider(),
            _buildInfoRow(
                Icons.phone, 'Phone Number', employee.phoneNumber.toString()),
            Divider(),
            _buildInfoRow(Icons.phone, 'Emergency Number',
                employee.phoneNumber.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: CustomColors.textColorEight),
          SizedBox(width: 8),
          Text('$label:',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CustomColors.textColorEight)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CustomColors.textColorTwo,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
