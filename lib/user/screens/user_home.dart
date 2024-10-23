import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/notifications/notification_class.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/screens/cart_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../auth/model/usermodel.dart';
import '../../generated/l10n.dart';
import '../providers/user_provider.dart';
import '../widgets/service_card.dart';
import '../widgets/heading_text.dart';
import '../widgets/product_card.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  // Function to build shimmer effect for text
  Widget buildShimmerText({double width = 100, double height = 20}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();

    // Fetch the necessary data
    userProvider.fetchCategories();
    userProvider.fetchProducts();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with logo, welcome text, and icons
              Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        child: SvgPicture.asset("assets/images/logo.svg"),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return userProvider.isLoading.value
                                ? buildShimmerText(
                                    width: 150,
                                    height: 20) // Shimmer for welcome text
                                : Text(
                                    S.of(context).welcome,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorFour),
                                  );
                          }),
                          FutureBuilder<UserModel?>(
                            future: getUserDetailsFromLocal(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Row(
                                  children: [
                                    buildShimmerText(width: 150, height: 20),
                                  ],
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    snapshot.data!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorTwo),
                                  );
                                } else {
                                  return Text(
                                    "User not found",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorTwo),
                                  );
                                }
                              } else {
                                return Text(
                                  "Unexpected error",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: CustomColors.textColorTwo),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Obx(() {
                    return userProvider.isLoading.value
                        ? Row(
                            children: [
                              buildShimmerText(
                                  width: 40,
                                  height: 40), // Shimmer for bell icon
                              const SizedBox(width: 10),
                              buildShimmerText(
                                  width: 40,
                                  height: 40), // Shimmer for cart icon
                            ],
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  NotificationService().showNotification(
                                      title: 'Sample title', body: 'It works!');
                                },
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                        "assets/images/icon_bell.svg"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => CartPage());
                                },
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                        "assets/images/cart.svg"),
                                  ),
                                ),
                              )
                            ],
                          );
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Promotional banner section with shimmer
              Obx(() {
                if (userProvider.isLoading.value) {
                  return Stack(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: const DecorationImage(
                              image: AssetImage("assets/images/sub_bg.png"),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildShimmerText(
                                    width: 180,
                                    height: 20), // Shimmer for title
                                const SizedBox(height: 5),
                                buildShimmerText(
                                    width: 250,
                                    height: 25), // Shimmer for description
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: 250,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              CustomColors.boneColor),
                                    ),
                                    onPressed: () {
                                      // Handle button press
                                    },
                                    child: Row(
                                      children: [
                                        const Image(
                                          width: 15,
                                          height: 15,
                                          image: AssetImage(
                                              "assets/images/sub_button_icon.png"),
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 10),
                                        buildShimmerText(
                                            width: 130,
                                            height:
                                                15), // Shimmer for button text
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // When not loading, show actual content here
                return Stack(
                  children: [
                    const Image(
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/sub_bg.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).youAreMissingout,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            S.of(context).subscribeAndsave,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    CustomColors.boneColor),
                              ),
                              onPressed: () {
                                // Handle button press
                              },
                              child: Row(
                                children: [
                                  const Image(
                                    width: 15,
                                    height: 15,
                                    image: AssetImage(
                                        "assets/images/sub_button_icon.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    S.of(context).subscriptionPlans,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              Obx(() {
                return userProvider.isLoading.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child:
                            HeadingText(headingText: S.of(context).ourServices),
                      )
                    : HeadingText(headingText: S.of(context).ourServices);
              }),
              Obx(() {
                if (userProvider.isLoading.value) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 22),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 80,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                }

                if (userProvider.categoryList.isEmpty) {
                  return const Center(child: Text("No categories found"));
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

              const SizedBox(height: 10),

              Obx(() {
                return userProvider.isLoading.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: HeadingText(
                            headingText: S.of(context).recommendedProducts),
                      )
                    : HeadingText(
                        headingText: S.of(context).recommendedProducts);
              }),
              Obx(() {
                if (userProvider.isLoading.value) {
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (userProvider.products.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = userProvider.products[index];
                      return ProductCard(product: product);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
