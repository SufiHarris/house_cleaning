import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/user/models/service_model.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';
import '../widgets/review_tab.dart';

class ApartmentServiceDetail extends StatefulWidget {
  final CategoryModel category;

  const ApartmentServiceDetail({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<ApartmentServiceDetail> createState() => _ApartmentServiceDetailState();
}

class _ApartmentServiceDetailState extends State<ApartmentServiceDetail>
    with SingleTickerProviderStateMixin {
  final userProvider = Get.find<UserProvider>();

  Map<int, List<ServiceItem>> selectedServices = {};
  double totalPrice = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchServices();
  }

  void _fetchServices() {
    userProvider.fetchServicesByCategory(widget.category.categoryType);
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
          _buildTopImageSection(category),
          _buildBackButton(),
          _buildMainContent(),
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

  Widget _buildMainContent() {
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
                      review: reviews,
                    ),
                  ],
                ),
              ),
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
        // insets: EdgeInsets.symmetric(horizontal: 40.0),
      ),
      controller: _tabController,
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centering the content
            children: [
              SvgPicture.asset(
                "assets/images/broom.svg",
                height: 20, // Adjust icon size if necessary
              ),
              const SizedBox(width: 8), // Adding space between icon and text
              Text("Service"),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centering the content
            children: [
              SvgPicture.asset(
                "assets/images/star.svg",
                height: 20, // Adjust icon size if necessary
              ),
              const SizedBox(width: 8), // Adding space between icon and text
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
              "Experience top-notch home cleaning with our expert team. Quick, reliable, and thorough—making your home sparkle effortlessly!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CustomColors.textColorFour,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            Text(
              "Add Rooms & Size",
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
    return Column(
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
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: Row(
                    children: [
                      SvgPicture.asset("assets/images/add.svg"),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("ADD")
                    ],
                  ),
                  onPressed: () => _addService(service),
                ),
              ],
            ),
          ],
        ),
        ...selectedServices[service.serviceId]?.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: _buildSelectedServiceItem(service, item),
                )) ??
            [],
      ],
    );
  }

  Widget _buildSelectedServiceItem(ServiceModel service, ServiceItem item) {
    return Container(
      // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text('${service.serviceName} X ${item.quantity}'),
            const Spacer(),
            Container(
              //  width: 100,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: () => _updateServiceQuantity(service, item, -1),
                  ),
                  Text('${item.size}M'),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () => _updateServiceQuantity(service, item, 1),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _removeService(service, item),
            ),
          ],
        ),
      ),
    );
  }

  void _addService(ServiceModel service) {
    setState(() {
      if (selectedServices[service.serviceId] == null) {
        selectedServices[service.serviceId] = [];
      }
      selectedServices[service.serviceId]!
          .add(ServiceItem(quantity: 1, size: 30));
      _updateTotalPrice();
    });
  }

  void _removeService(ServiceModel service, ServiceItem item) {
    setState(() {
      selectedServices[service.serviceId]?.remove(item);
      if (selectedServices[service.serviceId]?.isEmpty ?? false) {
        selectedServices.remove(service.serviceId);
      }
      _updateTotalPrice();
    });
  }

  void _updateServiceQuantity(
      ServiceModel service, ServiceItem item, int change) {
    setState(() {
      item.size = (item.size + change).clamp(1, 100);
      _updateTotalPrice();
    });
  }

  void _updateTotalPrice() {
    totalPrice = 0;
    selectedServices.forEach((serviceId, items) {
      ServiceModel service =
          userProvider.services.firstWhere((s) => s.serviceId == serviceId);
      items.forEach((item) {
        totalPrice += (item.size / 30) * service.price;
      });
    });
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(review.userImage),
          ),
          title: Text(review.userName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(review.rating.toString()),
                ],
              ),
              const SizedBox(height: 4),
              Text(review.comment),
            ],
          ),
        );
      },
    );
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
                // Handle booking action
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
}

class ServiceItem {
  int quantity;
  int size;

  ServiceItem({required this.quantity, required this.size});
}
