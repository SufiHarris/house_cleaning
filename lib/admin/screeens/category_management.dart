import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/admin/screeens/add_category.dart';
import 'package:house_cleaning/admin/screeens/edit_category.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/models/category_model.dart';

class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final adminProvider = Get.find<AdminProvider>(); // GetX controller
  String searchQuery = '';
  String currentLangCode = 'en'; // Default to English

  @override
  void initState() {
    super.initState();
    adminProvider.fetchCategories(); // Fetch categories when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
        actions: [
          // Language switcher between 'en' and 'ar'
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              setState(() {
                currentLangCode = currentLangCode == 'en' ? 'ar' : 'en';
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Add Button Row
            _buildSearchBar(),
            SizedBox(height: 10),
            // Category List
            Expanded(
              child: Obx(() {
                final categories = adminProvider.categories
                    .where((category) => category
                        .getLocalizedCategoryName(currentLangCode)
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

                if (categories.isEmpty) {
                  return Center(child: Text('No categories found'));
                } else {
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryCard(category);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar and Add Button Widget
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by name",
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColors.textfieldBorderColor, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColors.textfieldBorderColor, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            // Navigate to add category screen
            Get.to(AddCategoryScreen()); // Assuming AddCategoryScreen exists
          },
          child: Container(
            decoration: BoxDecoration(
                color: CustomColors.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: CustomColors.eggPlant,
                  ),
                  Text(
                    'ADD',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.eggPlant,
                        ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // Category Card Widget with ImageUrl support
  Widget _buildCategoryCard(CategoryModel category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display category image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    category.imageUrl, // Use category image URL here
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                // Display category name based on selected language
                Expanded(
                  child: Text(
                    category.getLocalizedCategoryName(currentLangCode),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to edit category screen (assuming EditCategoryScreen exists)
                    Get.to(() => EditCategoryScreen(category: category));
                  },
                  child: Icon(
                    Icons.edit,
                    color: CustomColors.primaryColor,
                  ),
                )
              ],
            ),
            Divider(),
            Text(
              'Description: ${category.getLocalizedDescription(currentLangCode) ?? 'No description'}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CustomColors.textColorTwo),
            ),
          ],
        ),
      ),
    );
  }
}
