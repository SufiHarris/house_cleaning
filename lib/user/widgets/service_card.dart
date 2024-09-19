import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/user_service_detail_screen.dart';

import '../../theme/custom_colors.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: InkWell(
          onTap: () {
            Get.to(() => UserServiceDetailPage(service: service));
          },
          child: Row(
            children: [
              Image(
                height: 50,
                width: 49,
                image: AssetImage(service.imageUrl),
              ),
              const Spacer(flex: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CustomColors.primaryColor),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        service.rating.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: CustomColors.textColorFour),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${service.reviews.length} reviews",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: CustomColors.textColorFour),
                      )
                    ],
                  )
                ],
              ),
              const Spacer(
                flex: 5,
              ),
              SvgPicture.asset("assets/images/right_chevron.svg")
            ],
          ),
        ),
      );
    });
  }
}
