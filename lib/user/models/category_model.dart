class CategoryModel {
  final String categoryName;
  final String categoryNameAr;
  final String categoryType;
  final String imageUrl;
  final String categoryImage; // New field
  final String description;
  final String descriptionAr; // New field

  CategoryModel(
      {required this.categoryName,
      required this.categoryNameAr,
      required this.categoryType,
      required this.imageUrl,
      required this.categoryImage,
      required this.description,
      required this.descriptionAr});

  // From JSON (Firestore document)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        categoryName: json['Category_Name'] ?? '',
        categoryNameAr: json['Category_Name(ar)'] ?? '',
        categoryType: json['Category_Type'],
        imageUrl: json['ImageUrl'],
        categoryImage: json['categoryImage'], // New field
        description: json['description'],
        descriptionAr: json['description(ar)'] // New field
        );
  }
  String getLocalizedCategoryName(String langCode) {
    if (langCode == 'ar') {
      return categoryNameAr;
    } else {
      return categoryName;
    }
  }

  String getLocalizedDescription(String langCode) {
    if (langCode == 'ar') {
      return descriptionAr;
    } else {
      return description;
    }
  }

  // To JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'Category_Name(en)': categoryName, // English category name
      'Category_Name(ar)': categoryNameAr,
      'Category_Type': categoryType,
      'ImageUrl': imageUrl,
      'categoryImage': categoryImage, // New field
      'description': description, // New field
    };
  }
}
