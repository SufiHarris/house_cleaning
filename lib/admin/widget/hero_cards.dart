import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class HeroCard extends StatelessWidget {
  final String iconName;
  final String number;
  final String status;

  const HeroCard({
    super.key,
    required this.number,
    required this.status,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = screenWidth * 0.45; // 45% of screen width

        return Container(
          padding: const EdgeInsets.all(12),
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconName,
                width: 40,
                height: 40,
                placeholderBuilder: (BuildContext context) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      status,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: CustomColors.textColorOne,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
