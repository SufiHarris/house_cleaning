import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/user/models/service_model.dart';
import '../../theme/custom_colors.dart';
import '../models/service_summary_model.dart';
import '../providers/user_provider.dart';
import '../widgets/review_tab.dart';
import 'user_select_address.dart';

class UserVehicleCleaningServiceScreen extends StatefulWidget {
  final CategoryModel category;

  const UserVehicleCleaningServiceScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<UserVehicleCleaningServiceScreen> createState() =>
      _UserVehicleCleaningServiceScreenState();
}

class _UserVehicleCleaningServiceScreenState
    extends State<UserVehicleCleaningServiceScreen>
    with SingleTickerProviderStateMixin {
  final userProvider = Get.find<UserProvider>();

  Map<int, List<ServiceItem>> selectedServices = {};
  List<ServiceSummaryModel> bookedServices = [];
  double totalPrice = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchServices();

    userProvider.updateMyString(widget.category.categoryImage);
    userProvider.setSelectedCategory(widget.category);
    userProvider.fetchServicesByCategory(widget.category.categoryName);
  }

  void _fetchServices() {
    userProvider.fetchServicesByCategory(widget.category.categoryType);
  }

  // Method to fetch reviews based on category

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
          _buildTopImageSection(category),
          _buildBackButton(),
          _buildMainContent(category),
          _buildBottomFixedSection(),
        ],
      ),
    );
  }

  Widget _buildTopImageSection(CategoryModel category) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(category.categoryImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/images/chevron_left.svg",
              width: 10,
              height: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(CategoryModel category) {
    return DraggableScrollableSheet(
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
              _buildCategoryTitle(),
              const SizedBox(height: 10),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLayoutSelectionScreen(scrollController),
                    ReviewsTab(
                      review: userProvider.reviews,
                      category: category,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Text(
            widget.category.categoryType,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1,
                  height: 1,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelColor: CustomColors.primaryColor,
      unselectedLabelColor: CustomColors.textColorFour,
      indicatorColor: CustomColors.primaryColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: CustomColors.primaryColor),
      ),
      controller: _tabController,
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/broom.svg",
                height: 20,
              ),
              const SizedBox(width: 8),
              Text("Service"),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/star.svg",
                height: 20,
              ),
              const SizedBox(width: 8),
              Text("Reviews"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutSelectionScreen(ScrollController scrollController) {
    return Obx(() {
      if (userProvider.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (userProvider.services.isEmpty) {
        return Center(child: Text('No services available'));
      } else {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              "Experience top-notch vehicle cleaning with our expert team. Quick, reliable, and thorough—making your vehicle sparkle effortlessly!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CustomColors.textColorFour,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            Text(
              "Add Vehicles",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CustomColors.textColorTwo,
              ),
            ),
            const SizedBox(height: 8),
            ...userProvider.services
                .map((service) => _buildServiceItem(service)),
            const SizedBox(height: 50),
          ],
        );
      }
    });
  }

  Widget _buildServiceItem(ServiceModel service) {
    bool isSelected = selectedServices.containsKey(service.serviceId);
    int quantity =
        isSelected ? selectedServices[service.serviceId]![0].quantity : 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: CustomColors.boneColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(service.image),
                ),
              ),
              const SizedBox(width: 10),
              Text(service.serviceName, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${service.price} SAR',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Spacer(),
                  if (isSelected) ...[
                    _buildCircularButton(
                      icon: Icons.remove,
                      onPressed: () => _updateServiceQuantity(service, -1),
                      bgColor: Colors.grey[200]!,
                    ),
                    SizedBox(width: 12),
                    Text(
                      '$quantity',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(width: 12),
                    _buildCircularButton(
                      icon: Icons.add,
                      onPressed: () => _updateServiceQuantity(service, 1),
                      bgColor: Colors.grey[200]!,
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () => _addService(service),
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color bgColor,
    Color iconColor = Colors.black54,
  }) {
    return InkWell(
      onTap: onPressed,
      customBorder: CircleBorder(),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }

  void _addService(ServiceModel service) {
    setState(() {
      selectedServices[service.serviceId] = [ServiceItem(quantity: 1)];
      _updateTotalPrice();
    });
  }

  void _updateServiceQuantity(ServiceModel service, int change) {
    setState(() {
      if (selectedServices.containsKey(service.serviceId)) {
        int newQuantity =
            selectedServices[service.serviceId]![0].quantity + change;
        if (newQuantity > 0) {
          selectedServices[service.serviceId]![0].quantity = newQuantity;
        } else {
          selectedServices.remove(service.serviceId);
        }
        _updateTotalPrice();
      }
    });
  }

  void _updateTotalPrice() {
    totalPrice = 0;
    selectedServices.forEach((serviceId, items) {
      ServiceModel service =
          userProvider.services.firstWhere((s) => s.serviceId == serviceId);
      items.forEach((item) {
        totalPrice += item.quantity * service.price;
      });
    });
  }

  Widget _buildBottomFixedSection() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: CustomColors.primaryColor, width: 0.1),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(
                    color: CustomColors.textColorFour,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${totalPrice.toStringAsFixed(2)} SAR',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _generateServiceSummary();
                Get.to(() => UserSelectAddress());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateServiceSummary() {
    bookedServices.clear();
    Map<String, Map<String, dynamic>> consolidatedServices = {};

    selectedServices.forEach((serviceId, items) {
      ServiceModel service =
          userProvider.services.firstWhere((s) => s.serviceId == serviceId);

      if (!consolidatedServices.containsKey(service.serviceName)) {
        consolidatedServices[service.serviceName] = {
          'totalQuantity': 0,
          'totalPrice': 0.0,
        };
      }

      items.forEach((item) {
        consolidatedServices[service.serviceName]!['totalQuantity'] +=
            item.quantity;
        consolidatedServices[service.serviceName]!['totalPrice'] +=
            item.quantity * service.price;
      });
    });

    consolidatedServices.forEach((serviceName, serviceDetails) {
      bookedServices.add(ServiceSummaryModel(
        serviceName: serviceName,
        totalQuantity: serviceDetails['totalQuantity'],
        totalSize: 0, // Not applicable for vehicle cleaning
        totalPrice: serviceDetails['totalPrice'],
      ));
    });

    userProvider.setSelectedServices(bookedServices);
    userProvider.fetchAddresses();
  }
}

class ServiceItem {
  int quantity;
  ServiceItem({required this.quantity});
}
