import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/user_product_detail_page.dart';
// import '../models/product_model.dart';
import '../../generated/l10n.dart';
import '../providers/user_provider.dart';
import '../widgets/product_card.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Get.put(UserProvider());
    // userProvider.fetchProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).products),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search for products and services',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
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
                    childAspectRatio: 0.8,
                  ),
                  itemCount: userProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = userProvider.products[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => UserProductDetailPage(product: product));
                      },
                      child: ProductCard(product: product),
                    );
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
