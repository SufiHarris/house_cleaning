class CategoryModel {
  final String categoryId; // Add this field
  final String categoryName;
  final String categoryNameAr;
  final String categoryType;
  final String imageUrl;
  final String categoryImage;
  final String description;
  final String descriptionAr;
  final String type;

  CategoryModel({
    required this.categoryId, // Include categoryId in the constructor
    required this.categoryName,
    required this.categoryNameAr,
    required this.categoryType,
    required this.imageUrl,
    required this.categoryImage,
    required this.description,
    required this.descriptionAr,
    required this.type,
  });

  // From JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['id'], // Extract the ID from the JSON
      categoryName: json['Category_Name'] ?? '',
      categoryNameAr: json['Category_Name(ar)'] ?? '',
      categoryType: json['Category_Type'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
      categoryImage: json['categoryImage'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['description(ar)'] ?? '',
      type: json['Type'] ?? '',
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
      'Category_Name': categoryName, // English category name
      'Category_Name(ar)': categoryNameAr,
      'Category_Type': categoryType,
      'ImageUrl': imageUrl,
      'categoryImage': categoryImage, // New field
      'description': description, // New field
      'description(ar)': descriptionAr, // Add Arabic description here
      'Type': type, // Add Arabic description here
    };
  }
}
