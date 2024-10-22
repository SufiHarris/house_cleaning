import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/user/models/service_model.dart';
import 'package:house_cleaning/user/models/service_summary_model.dart';
import 'package:house_cleaning/user/screens/user_select_address.dart';
import '../../auth/model/staff_model.dart';
import '../../generated/l10n.dart';
import '../../theme/custom_colors.dart';
import '../models/bookings_model.dart';
import '../providers/user_provider.dart';
import '../widgets/review_tab.dart';
import 'package:intl/intl.dart';

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
  DateTime selectedDate = DateTime.now();
  String currentLangCode = Get.locale?.languageCode ?? 'en';
  String? selectedShift;
  List<String> availableShifts = [];
  Map<int, List<ServiceItem>> selectedServices = {};
  List<ServiceSummaryModel> bookedServices = [];
  double totalPrice = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchServices();
    _fetchReviews(); // Fetch reviews on initialization
    userProvider.fetchEmployees();
    userProvider.fetchBookings();

    if (userProvider.selectedDate.value == null) {
      userProvider.setSelectedDate(DateTime.now());
    }
    userProvider.updateMyString(widget.category.categoryImage);
    userProvider.setSelectedCategory(widget.category);
  }

  void _fetchServices() {
    userProvider.fetchServicesByCategory(widget.category.categoryType);
  }

  Future<void> _fetchReviews() async {
    // Fetch reviews based on the category and update the local reviews list
    userProvider.fetchReviewsByCategory(widget.category.categoryName);
    // Call setState to rebuild the widget with fetched reviews
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
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  S.of(context).selectDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: CalendarDatePicker(
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                      userProvider.setSelectedDate(selectedDate);
                      _updateAvailableShifts(selectedDate);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDateButton(S.of(context).today, () {
                      setState(() {
                        selectedDate = DateTime.now();
                      });
                      Navigator.pop(context);
                    }),
                    _buildDateButton(S.of(context).tomorrow, () {
                      setState(() {
                        selectedDate =
                            DateTime.now().add(const Duration(days: 1));
                      });
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: CustomColors.primaryColor),
      ),
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: CustomColors.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Text(
            widget.category.getLocalizedCategoryName(currentLangCode),
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
              Text(S.of(context).service),
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
              Text(S.of(context).reviews),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutSelectionScreen(ScrollController scrollController) {
    return Obx(() {
      if (userProvider.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (userProvider.services.isEmpty) {
        return Center(child: Text(S.of(context).noServices));
      } else {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              widget.category.getLocalizedDescription(currentLangCode),
              // "Experience top-notch home cleaning with our expert team. Quick, reliable, and thorough—making your home sparkle effortlessly!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CustomColors.textColorFour,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 26),
            // Text(
            //   "Select Date",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //     color: CustomColors.textColorTwo,
            //   ),
            // ),
            _buildSelectOption(
              context: context,
              label: S.of(context).selectDate,
              value: selectedDate != null
                  ? DateFormat('d MMMM yyyy').format(selectedDate!)
                  : S.of(context).choose,
              onTap: () => _showDatePicker(context),
            ),
            const SizedBox(height: 16),
            _buildShiftSelection(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
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

  Widget _buildSelectOption({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColors.textColorThree),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: CustomColors.textColorThree,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: CustomColors.textColorThree),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
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
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.network(service.image),
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
                      const SizedBox(width: 10),
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
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '${item.price.toStringAsFixed(2)} SAR',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  _buildCircularButton(
                    icon: Icons.remove,
                    onPressed: item.size > service.baseSize
                        ? () => _updateServiceQuantity(service, item, -1)
                        : null,
                    bgColor: item.size > service.baseSize
                        ? Colors.grey[200]!
                        : Colors.grey[100]!,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${item.size}M',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  _buildCircularButton(
                    icon: Icons.add,
                    onPressed: () => _updateServiceQuantity(service, item, 1),
                    bgColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildCircularButton(
          icon: Icons.close,
          onPressed: () => _removeService(service, item),
          bgColor: Colors.red[50]!,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildShiftSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Shift",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CustomColors.textColorTwo,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              availableShifts.map((shift) => _buildShiftChip(shift)).toList(),
        ),
      ],
    );
  }

  void _updateAvailableShifts(DateTime selectedDate) {
    // Reset available shifts
    availableShifts = [];

    // Format the selected date to match the timestamp format in bookings
    String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    // Get data from provider
    List<StaffModel> allEmployees = userProvider.allEmployees;
    List<BookingModel> bookings = userProvider.bookings;

    // Get today's bookings - modify the comparison to handle timestamp format
    List<BookingModel> todaysBookings = bookings.where((booking) {
      // Parse the booking date which is in timestamp format
      DateTime bookingDate = DateTime.parse(booking.bookingDate);
      // Compare only the date part
      String bookingDateStr = DateFormat('yyyy-MM-dd').format(bookingDate);
      return bookingDateStr == selectedDateStr;
    }).toList();

    // Rest of the logic remains the same
    Set<String> morningEmployees = Set<String>();
    Set<String> afternoonEmployees = Set<String>();

    for (var booking in todaysBookings) {
      for (var shiftName in booking.shift_names) {
        if (shiftName == "Morning") {
          morningEmployees.addAll(booking.employee_ids);
        } else if (shiftName == "Afternoon") {
          afternoonEmployees.addAll(booking.employee_ids);
        }
      }
    }

    // Calculate available employees for each shift
    List<StaffModel> availableMorningStaff = allEmployees
        .where((employee) => !morningEmployees.contains(employee.employeeId))
        .toList();

    List<StaffModel> availableAfternoonStaff = allEmployees
        .where((employee) => !afternoonEmployees.contains(employee.employeeId))
        .toList();

    // Debug prints to help identify issues
    print("Selected date: $selectedDateStr");
    print(
        "Booking dates available: ${bookings.map((b) => b.bookingDate).toList()}");
    print("Today's bookings found: ${todaysBookings.length}");
    print("Available morning staff: ${availableMorningStaff.length}");
    print("Available afternoon staff: ${availableAfternoonStaff.length}");

    // Add shifts only if staff is available
    if (availableMorningStaff.isNotEmpty) {
      availableShifts.add("Morning");
    }
    if (availableAfternoonStaff.isNotEmpty) {
      availableShifts.add("Afternoon");
    }

    // Reset selected shift if it's no longer available
    if (selectedShift != null && !availableShifts.contains(selectedShift)) {
      selectedShift = null;
    }

    // Show message if no shifts are available
    if (availableShifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "No shifts available for this date - all employees are booked."),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {});
  }

  Widget _buildShiftChip(String shift) {
    bool isSelected = selectedShift == shift;
    return FilterChip(
      label: Text(shift),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          selectedShift = selected ? shift : null;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: CustomColors.primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? CustomColors.primaryColor : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: CustomColors.primaryColor,
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    VoidCallback? onPressed,
    required Color bgColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor ?? Colors.black, size: 16),
      ),
    );
  }

  void _addService(ServiceModel service) {
    setState(() {
      if (selectedServices[service.serviceId] == null) {
        selectedServices[service.serviceId] = [];
      }

      // Use baseSize and basePrice for the initial service item
      selectedServices[service.serviceId]!.add(
        ServiceItem(
            quantity: 1, size: service.baseSize, price: service.basePrice),
      );

      _updateTotalPrice();
    });
  }

  void _updateServiceQuantity(
      ServiceModel service, ServiceItem item, int change) {
    setState(() {
      int newSize = (item.size + change).clamp(service.baseSize, 100);
      int additionalSize = newSize - service.baseSize;
      int newPrice = service.basePrice + (additionalSize * service.price);

      item.size = newSize;
      item.price = newPrice;

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

  void _updateTotalPrice() {
    totalPrice = 0;
    selectedServices.forEach((serviceId, items) {
      items.forEach((item) {
        totalPrice += item.price;
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
                // Generate service summary before printing
                _generateServiceSummary();
                // Print the booked services
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

    // Consolidate services of the same type
    selectedServices.forEach((serviceId, items) {
      ServiceModel service =
          userProvider.services.firstWhere((s) => s.serviceId == serviceId);

      if (!consolidatedServices.containsKey(service.serviceName)) {
        consolidatedServices[service.serviceName] = {
          'totalQuantity': 0,
          'totalSize': 0,
          'totalPrice': 0.0,
        };
      }

      // Summing up size, quantity, and price for each service type
      items.forEach((item) {
        consolidatedServices[service.serviceName]!['totalQuantity'] +=
            item.quantity;
        consolidatedServices[service.serviceName]!['totalSize'] += item.size;
        consolidatedServices[service.serviceName]!['totalPrice'] += item.price;
      });
    });

    // Convert consolidated services to a list of ServiceSummaryModel
    consolidatedServices.forEach((serviceName, serviceDetails) {
      bookedServices.add(ServiceSummaryModel(
        serviceName: serviceName,
        totalQuantity: serviceDetails['totalQuantity'],
        totalSize: serviceDetails['totalSize'],
        totalPrice: serviceDetails['totalPrice'],
      ));
    });

    userProvider.setSelectedServices(bookedServices);
    userProvider.fetchAddresses();
  }
}

class ServiceItem {
  int quantity;
  int size;
  int price;

  ServiceItem(
      {required this.quantity, required this.size, required this.price});
}
