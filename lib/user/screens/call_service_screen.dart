import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/models/service_model.dart';
import 'package:house_cleaning/user/providers/user_provider.dart';
import 'package:house_cleaning/user/widgets/review_tab.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import 'call_booking_address.dart';
import 'user_select_address.dart';

class CallServiceScreen extends StatefulWidget {
  final CategoryModel category;

  const CallServiceScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CallServiceScreenState createState() => _CallServiceScreenState();
}

class _CallServiceScreenState extends State<CallServiceScreen> {
  DateTime? selectedDate;
  final userProvider = Get.find<UserProvider>();
  String currentLangCode = Get.locale?.languageCode ?? 'en';

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool isStartTimeAM = true;
  bool isEndTimeAM = true;
  bool isLoading = false;

  bool get isTimeSelected =>
      selectedStartTime != null && selectedEndTime != null;
  bool get canBookService => selectedDate != null && isTimeSelected;

  @override
  void initState() {
    super.initState();
    userProvider.fetchReviewsByCategory(widget.category.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Image Section
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.category.categoryImage),
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
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 18),
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
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          widget.category
                              .getLocalizedCategoryName(currentLangCode),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: CustomColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -1,
                                    height: 1,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TabBar(
                        labelColor: CustomColors.primaryColor,
                        unselectedLabelColor: CustomColors.textColorFour,
                        indicatorColor: CustomColors.primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 2.0, color: CustomColors.primaryColor),
                        ),
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
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildServiceDetails(context),
                            ReviewsTab(
                              review: userProvider.reviews,
                              category: widget.category,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: canBookService
                              ? () => _navigateToAddressSelection()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primaryColor,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Book Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

// In CallServiceScreen
  void _navigateToAddressSelection() {
    // Create a booking data model to pass
    final bookingData = {
      'date': selectedDate,
      'startTime': selectedStartTime,
      'endTime': selectedEndTime,
      'isStartTimeAM': isStartTimeAM,
      'isEndTimeAM': isEndTimeAM,
      'category': widget.category,
    };
    userProvider.fetchAddresses();

    Get.to(() => CallBookingAddress(
        category: widget.category,
        selectedDate: selectedDate!,
        startTime: selectedStartTime!,
        endTime: selectedEndTime!,
        isStartTimeAM: isStartTimeAM,
        isEndTimeAM: isEndTimeAM));
  }

  Widget _buildServiceDetails(BuildContext context) {
    String formatTimeOfDay(TimeOfDay? time, bool isAM) {
      if (time == null) return S.of(context).choose;
      final hour = isAM ? time.hourOfPeriod : time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute ${isAM ? 'AM' : 'PM'}';
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.category.getLocalizedDescription(currentLangCode),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CustomColors.textColorFour,
                ),
          ),
          const SizedBox(height: 32),
          _buildSelectOption(
            context: context,
            label: S.of(context).selectDate,
            value: selectedDate != null
                ? DateFormat('d MMMM yyyy').format(selectedDate!)
                : S.of(context).choose,
            onTap: () => _showDatePicker(context),
          ),
          _buildSelectOption(
            context: context,
            label: S.of(context).selectTime,
            value:
                "${formatTimeOfDay(selectedStartTime, isStartTimeAM)} - ${formatTimeOfDay(selectedEndTime, isEndTimeAM)}",
            onTap: () => _showTimePicker(context),
          ),
        ],
      ),
    );
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
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: CustomColors.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(color: CustomColors.primaryColor),
      ),
    );
  }

  Widget _buildTimeSelectionRow({
    required String label,
    required bool isStartTime,
    required TimeOfDay? selectedTime,
    required bool isAM,
    required Function(TimeOfDay) onTimeSelected,
    required Function(bool) onAMPMChanged,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: CustomColors.primaryColor,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    onTimeSelected(picked);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedTime?.format(context) ?? S.of(context).selectTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildAMPMToggle(
              isAM: isAM,
              onAMPMChanged: onAMPMChanged,
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAMPMButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : CustomColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAMPMToggle({
    required bool isAM,
    required Function(bool) onAMPMChanged,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildAMPMButton(
            text: S.of(context).am,
            isSelected: isAM,
            onTap: () => onAMPMChanged(true),
          ),
          _buildAMPMButton(
            text: S.of(context).pm,
            isSelected: !isAM,
            onTap: () => onAMPMChanged(false),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      S.of(context).timeAvailability,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildTimeSelectionRow(
                          label: S.of(context).availableFrom,
                          isStartTime: true,
                          selectedTime: selectedStartTime,
                          isAM: isStartTimeAM,
                          onTimeSelected: (TimeOfDay time) {
                            setModalState(() {
                              selectedStartTime = time;
                            });
                            setState(() {
                              selectedStartTime = time;
                            });
                          },
                          onAMPMChanged: (bool isAM) {
                            setModalState(() {
                              isStartTimeAM = isAM;
                            });
                            setState(() {
                              isStartTimeAM = isAM;
                            });
                          },
                          context: context,
                        ),
                        const SizedBox(height: 16),
                        _buildTimeSelectionRow(
                          label: S.of(context).availableTo,
                          isStartTime: false,
                          selectedTime: selectedEndTime,
                          isAM: isEndTimeAM,
                          onTimeSelected: (TimeOfDay time) {
                            setModalState(() {
                              selectedEndTime = time;
                            });
                            setState(() {
                              selectedEndTime = time;
                            });
                          },
                          onAMPMChanged: (bool isAM) {
                            setModalState(() {
                              isEndTimeAM = isAM;
                            });
                            setState(() {
                              isEndTimeAM = isAM;
                            });
                          },
                          context: context,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: isTimeSelected
                              ? () {
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.black, width: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: isTimeSelected
                                ? CustomColors.primaryColor
                                : Colors.grey,
                          ),
                          child: Text(
                            S.of(context).confirm,
                            style: TextStyle(
                              color: isTimeSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
