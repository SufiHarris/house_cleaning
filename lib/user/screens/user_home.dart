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
                          "assets/images/profile_icon.svg",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 12, color: CustomColors.textColorOne),
                          ),
                          Text(
                            "Faezan Dar",
                            style: TextStyle(
                                fontSize: 18, color: CustomColors.textColorOne),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: SvgPicture.asset(
                      "assets/images/bell.svg",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for products and services',
                ),
              ),
              const SizedBox(height: 20),
              const Image(
                width: double.infinity,
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  "assets/images/cover_pic.png",
                ),
              ),
              const HeadingText(headingText: "Services"),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return ServiceCard(service: services[index]);
                },
              ),
              const HeadingText(headingText: "Products"),
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
