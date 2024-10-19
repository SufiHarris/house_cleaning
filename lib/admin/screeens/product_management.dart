import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/screeens/add_product_screen.dart';
import 'package:house_cleaning/admin/screeens/edit_product.dart';

import '../../theme/custom_colors.dart';
import '../../user/models/product_model.dart';
import '../provider/admin_provider.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final adminProvider = Get.find<AdminProvider>(); // Assuming you're using GetX
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    adminProvider.fetchProducts(); // Fetching products from AdminProvider
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Add Button Row
            _buildSearchBar(),
            SizedBox(height: 10),
            // Product List
            Expanded(
              child: Obx(() {
                final products = adminProvider.products
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

                if (products.isEmpty) {
                  return Center(child: Text('No products found'));
                } else {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
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
            Get.to(AddProductScreen());
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

  // Product Card Widget
  Widget _buildProductCard(UserProductModel product) {
    bool isDescriptionExpanded = false;

    return StatefulBuilder(builder: (context, setState) {
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      product.imageUrl,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Container(
                            width: 30,
                            height: 30,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
                          width: 30,
                          height: 30,
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
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => EditProductScreen(
                          product: product)); // Pass the selected product
                    },
                    child: Icon(
                      Icons.edit,
                      color: CustomColors.primaryColor,
                    ),
                  )
                ],
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.money,
                        size: 15, color: CustomColors.textColorEight),
                    SizedBox(width: 8),
                    Text('Price ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: CustomColors.textColorEight)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.price.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: CustomColors.textColorTwo,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDescriptionExpanded = !isDescriptionExpanded;
                  });
                },
                child: Row(
                  children: [
                    Text('Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: CustomColors.textColorEight)),
                    Spacer(),
                    Icon(
                      isDescriptionExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              if (isDescriptionExpanded)
                Text(
                    product.description ??
                        'No description available', // Show description or fallback
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: CustomColors.textColorTwo)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: CustomColors.textColorEight),
          SizedBox(width: 8),
          Text('$label:',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CustomColors.textColorEight)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CustomColors.textColorTwo,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}
