import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/notifications/notification_class.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/screens/cart_screen.dart';
import 'package:house_cleaning/user/screens/shimmer_screens/user_home_shimmer.dart';
import '../../auth/model/usermodel.dart';
import '../../generated/l10n.dart';
import '../providers/user_provider.dart';
import '../widgets/service_card.dart';
import '../widgets/heading_text.dart';
import '../widgets/product_card.dart';
// import '../widgets/user_home_shimmer.dart';  // Import the shimmer file

class UserHome extends StatelessWidget {
  const UserHome({super.key});

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
                                ? buildShimmerText(width: 150, height: 20)
                                : Text(
                                    S.of(context).welcome,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorFour),
                                  );
                          }),
                          Obx(() {
                            // Check if loading state is true
                            if (userProvider.isLoading.value) {
                              // If loading, show shimmer effect
                              return buildShimmerText(width: 150, height: 20);
                            }

                            // Otherwise, show FutureBuilder
                            return FutureBuilder<UserModel?>(
                              future: getUserDetailsFromLocal(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return buildShimmerText(
                                      width: 150, height: 20);
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
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
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Obx(() {
                    return userProvider.isLoading.value
                        ? Row(
                            children: [
                              buildShimmerText(width: 40, height: 40),
                              const SizedBox(width: 10),
                              buildShimmerText(width: 40, height: 40),
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
                return userProvider.isLoading.value
                    ? buildShimmerBanner()
                    : Stack(
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

              // Heading for "Our Services"
              Obx(() {
                return userProvider.isLoading.value
                    ? buildShimmerHeadingText(S.of(context).ourServices)
                    : HeadingText(headingText: S.of(context).ourServices);
              }),

              // Shimmer for services
              Obx(() {
                return userProvider.isLoading.value
                    ? buildShimmerServiceList(3)
                    : ListView.builder(
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

              // Heading for "Recommended Products"
              Obx(() {
                return userProvider.isLoading.value
                    ? buildShimmerHeadingText(S.of(context).recommendedProducts)
                    : HeadingText(
                        headingText: S.of(context).recommendedProducts);
              }),

              // Shimmer for recommended products
              Obx(() {
                return userProvider.isLoading.value
                    ? buildShimmerProductList(3)
                    : SizedBox(
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
