import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/user/models/review_model.dart';
import 'package:house_cleaning/user/providers/user_provider.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';

import '../models/service_model.dart';

class ReviewsTab extends StatelessWidget {
  final CategoryModel category;
  final List<Review> review;

  const ReviewsTab({
    super.key,
    required this.review,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildRatingOverview(context),
        const SizedBox(height: 24),
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
                  index < 5 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            Text(
              "  ${5} out of 5.0 ",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(),
            ),
          ],
        ),
        HeadingText(headingText: "What customers are saying"),
        ElevatedButton(
          onPressed: () async {
            // Call the method to add a review
            await _handleAddReview();
          },
          child: Text('+ Add Review'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 40),
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...review.map((review) => _buildReviewItem(review)),
          ],
        )
      ],
    );
  }

  Future<void> _handleAddReview() async {
    final userProvider = Get.find<UserProvider>();

    // Fetch user data (like name, profile, userId, email)
    Map<String, String> userData = await userProvider.fetchUserData();

    if (userData.isNotEmpty) {
      // Create the review model
      ReviewModel newReview = ReviewModel(
        userName: userData['userName'] ?? '',
        userProfile: userData['userProfile'] ?? '',
        userId: userData['userId'] ?? '',
        userEmail: userData['userEmail'] ?? '',
        reviewMessage:
            'Working on our mobile app has been an incredible experience. It\'s user-friendly, efficient, and constantly improving. I\'m proud to be part of a team that values creativity and excellence.', // Default review message for now
        rating: 5.0, // Default rating for now
        categoryName:
            category.categoryName, // Use the category from the constructor
      );

      // Add the review to Firestore
      await userProvider.addReviewToFirestore(newReview);
    } else {
      Get.snackbar('Error', 'Failed to fetch user data',
          backgroundColor: Colors.red);
    }
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(review.userImage),
                    radius: 10,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(review.userName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Text(review.rating.toString())
                    ],
                  )
                ],
              ),
              const SizedBox(width: 12),
              Text(review.comment),
            ],
          ),
        ),
      ),
    );
  }
}
