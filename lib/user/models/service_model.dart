class ServiceModel {
  final String serviceName; // English service name
  final String serviceNameAr; // Arabic service name
  final String serviceId; // Change to String (ensured)
  final String category; // English category name
  final String categoryAr; // Arabic category name
  final String image; // Image URL
  final int price; // Service price
  final int baseSize; // Base size
  final int basePrice; // Base price

  ServiceModel({
    required this.serviceName,
    required this.serviceNameAr, // Arabic service name
    required this.serviceId, // String serviceId
    required this.category,
    required this.categoryAr, // Arabic category
    required this.image,
    required this.price,
    required this.baseSize,
    required this.basePrice,
  });

  // From JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceName: json['service_name'] ?? '',
      serviceNameAr: json['service_name_ar'] ?? '',
      serviceId: (json['service_id'] ?? '')
          .toString(), // Ensure serviceId is String, even if Firestore stores it as int
      category: json['category'] ?? '',
      categoryAr: json['category_ar'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      baseSize: json['base_size'] ?? 10,
      basePrice: json['base_price'] ?? 0,
    );
  }

  // Get localized service name based on language code
  String getLocalizedServiceName(String langCode) {
    return langCode == 'ar' ? serviceNameAr : serviceName;
  }

  // Get localized category name based on language code
  String getLocalizedCategoryName(String langCode) {
    return langCode == 'ar' ? categoryAr : category;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'service_name_ar': serviceNameAr,
      'service_id': serviceId,
      'category': category,
      'category_ar': categoryAr,
      'image': image,
      'price': price,
      'base_size': baseSize,
      'base_price': basePrice,
    };
  }
}

class Review {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;

  Review({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
  });
}
