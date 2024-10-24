// user_service_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import '../providers/user_provider.dart';
import '../widgets/service_card.dart';

import 'shimmer_screens/user_services_shimmer.dart'; // Import the shimmer file

class UserServiceScreen extends StatelessWidget {
  const UserServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).services),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar with shimmer
            Obx(() {
              return userProvider.isLoading.value
                  ? buildShimmerSearchBar()
                  : const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search for products and services',
                      ),
                    );
            }),
            const SizedBox(height: 20),

            // Services List with shimmer
            Expanded(
              child: Obx(() {
                if (userProvider.isLoading.value) {
                  return buildShimmerServiceList(5);
                }

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
