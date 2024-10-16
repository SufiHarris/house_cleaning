import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import '../provider/admin_provider.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

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
              'Total Users',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Obx(() => Text(
                  '${adminProvider.usersList.length}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                  radius: 24,
                ),
                SizedBox(width: 16),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.email, 'Email', user.email),
            _buildInfoRow(Icons.phone, 'Phone', user.phone),
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
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          SizedBox(width: 8),
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
