import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/notifications/notification_class.dart';
import 'package:house_cleaning/tracking/google_map_widget.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/tracking/home_file.dart';
import 'package:house_cleaning/user/screens/cart_screen.dart';
import 'package:house_cleaning/user/screens/notification_page.dart';
import 'package:house_cleaning/user/screens/user_create_profile_screen.dart';
import '../models/notification_model.dart';
import '../providers/user_provider.dart';
import '../widgets/service_card.dart';
import '../widgets/heading_text.dart';
import '../widgets/product_card.dart';
import '../../theme/custom_colors.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();
    userProvider.fetchCategories();
    userProvider.fetchProducts();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          Text("Welcome",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: CustomColors.textColorFour)),
                          FutureBuilder<UserModel?>(
                            future: getUserDetailsFromLocal(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  "Loading...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: CustomColors.textColorTwo),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  print(
                                      'User loaded: ${snapshot.data!.name}'); // This should print if user data is successfully loaded
                                  return Text(
                                    snapshot.data!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorTwo),
                                  );
                                } else if (snapshot.hasError) {
                                  print(
                                      'Error in FutureBuilder: ${snapshot.error}');
                                  return Text(
                                    "Error loading user",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorTwo),
                                  );
                                } else {
                                  print(
                                      'Error: User not found or data is null');
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
                                print(
                                    'Unexpected connection state: ${snapshot.connectionState}');
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
                  GestureDetector(
                    onTap: () {
                      NotificationService().initNotification();
                      NotificationService().showNotification(
                          title: 'Sample title', body: 'It works!');
                      //Get.to(() => HomeFile());
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/images/icon_bell.svg"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CartPage());
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/images/cart.svg"),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // The rest of the widget tree remains unchanged...
              Stack(
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
                          "You’re missing out!!!",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Subscribe and save.",
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
                                  "Subscription Plans",
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
                  )
                ],
              ),
              const HeadingText(headingText: "Our Services"),
              Obx(() {
                if (userProvider.categoryList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
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
              const HeadingText(headingText: "Recommended Products"),
              Obx(() {
                if (userProvider.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
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
