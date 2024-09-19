import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

import '../models/service_model.dart';

class ReviewsTab extends StatelessWidget {
  final Service service;

  const ReviewsTab({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildRatingOverview(context),
        const SizedBox(height: 24),
        _buildReviewsList(),
      ],
    );
  }

  Widget _buildRatingOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer reviews',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: CustomColors.primaryColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Row(
              children: List.generate(
                  5,
                  (index) => Icon(
                        index < service.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 24,
                      )),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              service.rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Implement add review functionality
          },
          child: Text('+ Add Review'),
          style: ElevatedButton.styleFrom(
            // primary: Colors.white,
            // onPrimary: Colors.black,
            side: BorderSide(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What customers are saying',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...service.reviews.map((review) => _buildReviewItem(review)),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(review.userImage),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.userName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    ...List.generate(
                        5,
                        (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            )),
                    const SizedBox(width: 8),
                    Text(review.rating.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review.comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
