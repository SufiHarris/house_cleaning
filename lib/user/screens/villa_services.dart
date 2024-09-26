import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/screens/date_selection.dart';
import 'package:house_cleaning/user/screens/time_selection.dart';

import '../models/service_model.dart';
import '../widgets/review_tab.dart';
// import 'date_selection_page.dart'; // Replace with your actual DateSelectionPage import
// import 'time_selection_page.dart'; // Replace with your actual TimeSelectionPage import

class VillaServices extends StatefulWidget {
  // final Service service;
  final CategoryModel category; // Add this

  const VillaServices({
    super.key,
    // required this.service,
    required this.category, // Add this
  });
  @override
  State<VillaServices> createState() => _VillaServicesState();
}

class _VillaServicesState extends State<VillaServices>
    with SingleTickerProviderStateMixin {
  double totalPrice = 57.00;
  bool showDateTimeSelection = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Image Section (Dynamic image from category)
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    category.categoryImage), // Use dynamic category image
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                    Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
              ),
            ),
          ),
          // Main content
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          Text(
                            category.categoryType,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: CustomColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -1,
                                  height: 1,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Service'),
                        Tab(text: 'Reviews'),
                      ],
                      labelColor: CustomColors.primaryColor,
                      unselectedLabelColor: CustomColors.textColorFour,
                      indicatorColor: CustomColors.primaryColor,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildServiceDetails(scrollController),
                          ReviewsTab(review: reviews),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails(ScrollController scrollController) {
    final category = widget.category;
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          // Dynamic description
          Text(category.description, // Use dynamic description
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CustomColors.textColorFour,
                    letterSpacing: 0.5,
                    height: 1.5,
                  )),

          // Date and Time Buttons
          _buildSelectOption(
            context: context,
            // title: "Select Date",
            label: "Select Date",
            onTap: () => Get.to(() =>
                DateSelectionPage()), // Replace with your actual DateSelectionPage
          ),
          _buildSelectOption(
            context: context,
            // title: "Select Time",
            label: "Select Time",
            onTap: () => Get.to(() =>
                TimeSelectionPage()), // Replace with your actual TimeSelectionPage
          ),
        ],
      ),
    );
  }

  Widget _buildSelectOption({
    required BuildContext context,
    required String label, // Added label parameter
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label for "Select Date" or "Select Time"
        Text(
          label, // Dynamic label
          style: TextStyle(
            color: CustomColors.primaryColor, // Adjust color as needed
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8), // Add some spacing between label and button
        // Choose Button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: CustomColors.textColorThree, width: 1.0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "Choose",
                  style: TextStyle(
                    color: CustomColors.textColorThree,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
