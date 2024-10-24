import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import 'package:house_cleaning/user/screens/user_select_address.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';
import 'product_select_adress.dart';

class UserProductDetailPage extends StatefulWidget {
  final UserProductModel product;

  const UserProductDetailPage({Key? key, required this.product})
      : super(key: key);

  @override
  State<UserProductDetailPage> createState() => _UserProductDetailPageState();
}

class _UserProductDetailPageState extends State<UserProductDetailPage> {
  final List<String> feature = [
    "Feature 1",
    "Feature 2",
    "Feature 3",
    "Feature 4",
  ];

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Get.find<UserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Image Section
          Stack(
            children: [
              Container(
                height: 250, // Fixed height for the image
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.imageUrl),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/images/chevron_left.svg",
                      width: 20,
                      height: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Scrollable Details Section
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: CustomColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1,
                            height: 1,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "UltraVac 3000: Powerful, lightweight vacuum cleaner with advanced HEPA filtration. Perfect for all floor types and hard-to-reach areas. Keep your home spotless effortlessly!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CustomColors.textColorFour,
                            letterSpacing: 0.5,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "What's Included?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.textColorTwo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: feature
                          .map((feature) => Text(
                                '• $feature',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: CustomColors.textColorFour,
                                      letterSpacing: 0.5,
                                      height: 1.5,
                                    ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Customer Ratings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.textColorTwo,
                      ),
                    ),
                    const SizedBox(height: 20), // Add extra space at the bottom
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Fixed Section
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: CustomColors.primaryColor, width: 0.1),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                userProvider.fetchAddresses();
                // Show bottom sheet with SelectAddressPage
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ProductSelectAdress(
                      product: widget.product,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
