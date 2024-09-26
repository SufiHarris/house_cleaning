class CategoryModel {
  final String categoryName;
  final String categoryType;
  final String imageUrl;
  final String categoryImage; // New field
  final String description; // New field

  CategoryModel({
    required this.categoryName,
    required this.categoryType,
    required this.imageUrl,
    required this.categoryImage,
    required this.description,
  });

  // From JSON (Firestore document)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['Category_Name'],
      categoryType: json['Category_Type'],
      imageUrl: json['ImageUrl'],
      categoryImage: json['categoryImage'], // New field
      description: json['description'], // New field
    );
  }

  // To JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'Category_Name': categoryName,
      'Category_Type': categoryType,
      'ImageUrl': imageUrl,
      'categoryImage': categoryImage, // New field
      'description': description, // New field
    };
  }
}
