import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/confirm_order_screen.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';
import 'package:house_cleaning/user/widgets/recommend_product_widget.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button_widget.dart';

class ProductRecommendScreen extends StatelessWidget {
  ProductRecommendScreen({Key? key}) : super(key: key);

  final UserProvider userProvider = Get.find<UserProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommendation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            HeadingText(headingText: "People are also buying"),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (userProvider.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: userProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = userProvider.products[index];
                    return Obx(() => RecommendProduct(
                          product: product,
                          isSelected:
                              userProvider.selectedProducts.contains(product),
                          onToggle: () =>
                              userProvider.toggleProductSelection(product),
                        ));
                  },
                );
              }),
            ),
            CustomButton(
              text: "Next",
              onTap: () {
                // Here you can navigate to the final confirmation page
                // or submit the data to your backend
                print("Selected Date: ${userProvider.selectedDate.value}");
                print("Selected Services: ${userProvider.selectedServices}");
                print(
                    "Selected Address: ${userProvider.selectedAddress.value}");
                print("Selected Products: ${userProvider.selectedProducts}");

                // Navigate to final confirmation page or submit data
                Get.to(() => ConfirmOrderScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
