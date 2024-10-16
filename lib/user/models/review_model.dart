class ReviewModel {
  String? reviewId;
  String userName;
  String userProfile;
  String userId;
  String userEmail;
  String reviewMessage;
  double rating;
  String categoryName;

  ReviewModel({
    this.reviewId,
    required this.userName,
    required this.userProfile,
    required this.userId,
    required this.userEmail,
    required this.reviewMessage,
    required this.rating,
    required this.categoryName,
  });

  // Convert a ReviewModel object into a map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'review_id': reviewId,
      'user_name': userName,
      'user_profile': userProfile,
      'user_id': userId,
      'user_email': userEmail,
      'review_message': reviewMessage,
      'rating': rating,
      'category_name': categoryName,
    };
  }

  // Convert Firestore data into a ReviewModel object
  factory ReviewModel.fromFirestore(Map<String, dynamic> data) {
    return ReviewModel(
      reviewId: data['review_id'],
      userName: data['user_name'],
      userProfile: data['user_profile'],
      userId: data['user_id'],
      userEmail: data['user_email'],
      reviewMessage: data['review_message'],
      rating: data['rating'].toDouble(),
      categoryName: data['category_name'],
    );
  }
}
