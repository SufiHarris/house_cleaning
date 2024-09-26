import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../models/service_model.dart';
import '../providers/user_provider.dart';
import '../widgets/service_card.dart';

class UserServiceScreen extends StatelessWidget {
  const UserServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for products and services',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (userProvider.categoryList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userProvider.categoryList.length,
                  itemBuilder: (context, index) {
                    final category = userProvider.categoryList[index];
                    return ServiceCard(category: category);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
