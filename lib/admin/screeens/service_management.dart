import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/admin/screeens/add_service.dart';
import 'package:house_cleaning/admin/screeens/edit_service.dart';

import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/models/service_model.dart';

class ServiceManagementScreen extends StatefulWidget {
  @override
  _ServiceManagementScreenState createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final adminProvider = Get.find<AdminProvider>(); // GetX controller
  String searchQuery = '';
  String currentLangCode = 'en'; // Default to English

  @override
  void initState() {
    super.initState();
    adminProvider.fetchServices(); // Fetch services when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Management'),
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
            // Service List
            Expanded(
              child: Obx(() {
                final services = adminProvider.services
                    .where((service) => service.serviceName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

                if (services.isEmpty) {
                  return Center(child: Text('No services found'));
                } else {
                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return _buildServiceCard(service);
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
                  Radius.circular(
                      10.0), // Same corner radius as CategoryManagement
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColors.textfieldBorderColor, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                      10.0), // Same corner radius as CategoryManagement
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
            // Navigate to add service screen
            Get.to(AddServiceScreen()); // Assuming AddServiceScreen exists
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

  // Service Card Widget
  // Service Card Widget
  Widget _buildServiceCard(ServiceModel service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
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
                // Display service image with fallback handling
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    service.image, // Ensure this URL is valid
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
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
                // Display service name
                Expanded(
                  child: Text(
                    service.serviceName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to edit service screen
                    Get.to(() => EditServiceScreen(service: service));
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
              'Price: \$${service.price}',
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
