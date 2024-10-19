import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

import '../../generated/l10n.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int number;
  final String experience;

  const EmployeeCard(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.number,
      required this.experience});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.employeeBgOne,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomColors.employeeBgOne,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
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
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).employeeNameLabel,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: CustomColors.textColorSix),
                    ),
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: CustomColors.textColorSeven),
                    ),
                  ],
                ),
                Spacer(),
                SvgPicture.asset("assets/images/logo_lite.svg"),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomColors.employeeBgTwo,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).contactNumberLabel,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: CustomColors.textColorSix),
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,
                            size: 16, color: CustomColors.textColorSix),
                        SizedBox(width: 4),
                        Text(
                          number.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: CustomColors.textColorSeven),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).workExperienceLabel,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: CustomColors.textColorSix),
                    ),
                    Row(
                      children: [
                        Icon(Icons.work,
                            size: 16, color: CustomColors.textColorSix),
                        SizedBox(width: 4),
                        Text(
                          experience,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: CustomColors.textColorSeven),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
