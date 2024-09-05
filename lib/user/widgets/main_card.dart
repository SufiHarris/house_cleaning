import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

import '../../theme/custom_colors.dart';

class MainCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final double price;
  final double rating;
  final Color iconColor;

  const MainCard(
      {super.key,
      required this.icon,
      required this.name,
      required this.price,
      required this.rating,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: iconColor,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.textColorOne,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text('\$$price'),
                ),
                Row(
                  children: [
                    StarRating(
                      rating: rating,
                      size: 15,
                    ),
                    const Spacer()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
