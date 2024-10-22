import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/screeens/category_management.dart';
import 'package:house_cleaning/admin/screeens/employee_management.dart';
import 'package:house_cleaning/admin/screeens/product_management.dart';
import 'package:house_cleaning/admin/screeens/service_management.dart';
import 'package:house_cleaning/admin/screeens/user_management.dart';
import 'package:house_cleaning/admin/widget/management_widget.dart';

class AdminManagement extends StatelessWidget {
  const AdminManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(UserManagement());
              },
              child: ManagementWidget(
                  iconString: "assets/images/icon_bell.svg",
                  nameString: "Users"),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                Get.to(EmployeeManagement());
              },
              child: ManagementWidget(
                  iconString: "assets/images/icon_bell.svg",
                  nameString: "Employee"),
            ),
            Divider(),
            GestureDetector(
              onTap: () {},
              child: ManagementWidget(
                  iconString: "assets/images/icon_bell.svg",
                  nameString: "Notifications"),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                Get.to(ProductManagementScreen());
              },
              child: ManagementWidget(
                  iconString: "assets/images/icon_bell.svg",
                  nameString: "Products"),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                Get.to(
                    CategoryManagementScreen()); // Navigate to the new Category Management screen
              },
              child: ManagementWidget(
                  iconString: "assets/images/icon_bell.svg",
                  nameString:
                      "Categories"), // New option for Category Management
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                Get.to(
                    ServiceManagementScreen()); // Navigate to the new Category Management screen
              },
              child: ManagementWidget(
                  iconString: "assets/images/icon_bell.svg",
                  nameString: "Services"), // New option for Category Management
            ),
          ],
        ),
      ),
    );
  }
}
