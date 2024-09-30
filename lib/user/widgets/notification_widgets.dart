import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const NotificationItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: CustomColors.eggPlant, // Light background for icon
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 24, color: CustomColors.textColorTwo), // Brownish icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColors.textColorTwo,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CustomColors.textColorTwo,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
