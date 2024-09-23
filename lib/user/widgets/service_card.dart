import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../theme/custom_colors.dart';
import '../models/category_model.dart'; // Make sure this is the correct import path for your Category model

class ServiceCard extends StatelessWidget {
  final CategoryModel category;

  const ServiceCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: InkWell(
          onTap: () {
            // You can navigate to the detailed service page if needed
            // Get.to(() => UserServiceDetailPage(service: service));
          },
          child: Row(
            children: [
              // Static image for now
              Image.network(
                height: 40,
                fit: BoxFit.fill,
                category.imageUrl,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
              const Spacer(
                flex: 1,
              ),
              // Display the category name from Firestore
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.categoryName, // This comes from Firestore data
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: CustomColors.primaryColor),
                  ),
                  Row(
                    children: [
                      // Static rating for now
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        "4.5", // Static rating
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: CustomColors.textColorFour),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "50 reviews", // Static number of reviews
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: CustomColors.textColorFour),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(flex: 5),

              // Static chevron icon for now
              SvgPicture.asset("assets/images/right_chevron.svg"),
            ],
          ),
        ),
      );
    });
  }
}
