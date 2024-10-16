import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import '../provider/admin_provider.dart';

class EmployeeManagement extends StatelessWidget {
  const EmployeeManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Get.find<AdminProvider>();
    adminProvider.fetchUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Column(
        children: [
          _buildTotalUsersCard(adminProvider),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: adminProvider.usersList.length,
                  itemBuilder: (context, index) {
                    final user = adminProvider.usersList[index];
                    return _buildUserCard(user);
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalUsersCard(AdminProvider adminProvider) {
    return Card(
      color: Colors.white,
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

  Widget _buildUserCard(UserModel user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(
          // Adding the border
          color: Colors.grey.shade300, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8), // Optional: add rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user.image,
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
                              value: loadingProgress.expectedTotalBytes != null
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
                  user.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 16),
            _buildInfoRow(Icons.email, 'Email', user.email),
            Divider(),
            _buildInfoRow(Icons.phone, 'Phone', user.phone),
            Divider(),
            _buildInfoRow(Icons.location_on, 'Address',
                user.address.isNotEmpty ? user.address.first.landmark : 'N/A'),
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
