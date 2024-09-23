class CategoryModel {
  final String categoryName;
  final String categoryType;
  final String imageUrl;

  CategoryModel({
    required this.categoryName,
    required this.categoryType,
    required this.imageUrl,
  });

  // From JSON (Firestore document)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['Category_Name'],
      categoryType: json['Category_Type'],
      imageUrl: json['ImageUrl'],
    );
  }

  // To JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'Category_Name': categoryName,
      'Category_Type': categoryType,
      'ImageUrl': imageUrl,
    };
  }
}
