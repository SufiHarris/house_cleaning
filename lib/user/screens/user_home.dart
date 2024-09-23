import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/custom_colors.dart';
import '../models/product_model.dart';
import '../models/service_model.dart';
import '../widgets/heading_text.dart';
import '../widgets/product_card.dart';
import '../widgets/service_card.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
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
                        child: SvgPicture.asset(
                          "assets/images/logo.svg",
                        ),
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
                          Text(
                            "Faezan Dar",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: CustomColors.textColorTwo),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset("assets/images/icon_bell.svg"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  const Image(
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    image: AssetImage(
                      "assets/images/sub_bg.png",
                    ),
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
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Subscribe and save.",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
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
                                const SizedBox(
                                  width: 10,
                                ),
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

              // const HeadingText(headingText: "My Bookings"),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(20),
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.2),
              //           spreadRadius: 1,
              //           blurRadius: 3,
              //           offset: const Offset(1, 1),
              //         ),
              //       ],
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Row(
              //         children: [
              //           Text(
              //             "No bookings",
              //             style: TextStyle(
              //                 color: CustomColors.primaryColor,
              //                 fontWeight: FontWeight.w300),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const HeadingText(headingText: "Our Services"),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCard(service: service);
                },
              ),
              const HeadingText(headingText: "Recommended Products"),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
