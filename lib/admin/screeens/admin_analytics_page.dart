import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';
import 'package:http/http.dart';
import '../../theme/custom_colors.dart';
import '../provider/admin_provider.dart';
import '../../user/models/bookings_model.dart';

class RevenueGraphPage extends StatefulWidget {
  @override
  _RevenueGraphPageState createState() => _RevenueGraphPageState();
}

class _RevenueGraphPageState extends State<RevenueGraphPage> {
  final AdminProvider adminProvider = Get.find<AdminProvider>();
  RxInt selectedYear = DateTime.now().year.obs;

  @override
  void initState() {
    super.initState();
    adminProvider.fetchBookings(selectedYear.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeadingText(headingText: "Total Revenue"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<int>(
                      value: selectedYear.value,
                      items: List.generate(
                        5,
                        (index) => DropdownMenuItem(
                          value: DateTime.now().year - index,
                          child: Text('Year ${DateTime.now().year - index}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          selectedYear.value = value;
                          adminProvider.fetchBookings(value);
                        }
                      },
                    ),
                  ],
                ),
                // Revenue Graph and Loading Indicator
                Obx(() {
                  if (adminProvider.isLoading.value) {
                    return Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    final monthlyRevenue = getMonthlyRevenue(
                      adminProvider.bookings,
                      selectedYear.value,
                    );

                    final mostBookedCategory =
                        getMostBookedCategory(adminProvider.bookings);

                    final monthlyBookings = getMonthlyBookings(
                      adminProvider.bookings,
                      selectedYear.value,
                    );

                    return Column(
                      children: [
                        RevenueGraph(
                          monthlyRevenue: monthlyRevenue,
                        ),
                        const SizedBox(height: 20),
                        HeadingText(headingText: "Bookings Behaviour"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  offset: Offset(0, 1)),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                HeadingText(
                                    headingText: "Most booked services"),
                                MostBookedCategoryWidget(
                                    mostBookedCategory: mostBookedCategory),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        HeadingText(headingText: "Monthly Bookings"),
                        BookingsGraph(
                          monthlyBookings: monthlyBookings,
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to calculate monthly revenue
  Map<int, double> getMonthlyRevenue(
      List<BookingModel> bookings, int selectedYear) {
    Map<int, double> monthlyRevenue = {for (int i = 1; i <= 12; i++) i: 0.0};

    for (var booking in bookings) {
      DateTime bookingDate = DateTime.parse(booking.bookingDate);

      if (bookingDate.year == selectedYear) {
        monthlyRevenue[bookingDate.month] =
            (monthlyRevenue[bookingDate.month]! + (booking.total_price ?? 0.0));
      }
    }

    return monthlyRevenue;
  }

  // Method to calculate the most booked category
  ServiceCount getMostBookedCategory(List<BookingModel> bookings) {
    Map<String, ServiceCount> categoryCounts = {};

    // Loop through each booking
    for (var booking in bookings) {
      // If the category already exists in the map, increment its count
      if (categoryCounts.containsKey(booking.categoryName)) {
        categoryCounts[booking.categoryName] = ServiceCount(
          booking.categoryName,
          categoryCounts[booking.categoryName]!.count + 1,
          booking.categoryImage, // Image of the category
        );
      } else {
        // Otherwise, add it to the map with an initial count of 1 and the image
        categoryCounts[booking.categoryName] = ServiceCount(
          booking.categoryName,
          1,
          booking.categoryImage,
        );
      }
    }

    // Convert the map entries to a list of ServiceCount objects
    List<ServiceCount> categoryList =
        categoryCounts.entries.map((entry) => entry.value).toList();

    // Sort the list by booking count in descending order
    categoryList.sort((a, b) => b.count.compareTo(a.count));

    // Return the most booked category (top 1)
    return categoryList.isNotEmpty
        ? categoryList.first
        : ServiceCount('', 0, '');
  }

  // Method to calculate monthly bookings
  Map<int, int> getMonthlyBookings(
      List<BookingModel> bookings, int selectedYear) {
    Map<int, int> monthlyBookings = {for (int i = 1; i <= 12; i++) i: 0};

    for (var booking in bookings) {
      DateTime bookingDate = DateTime.parse(booking.bookingDate);

      if (bookingDate.year == selectedYear) {
        monthlyBookings[bookingDate.month] =
            (monthlyBookings[bookingDate.month]! + 1);
      }
    }

    return monthlyBookings;
  }
}

// A simple data class for category count
class ServiceCount {
  final String name; // This will be the categoryName
  final int count; // Number of bookings in this category
  final String imageUrl; // Image of the category

  ServiceCount(this.name, this.count, this.imageUrl);
}

// The widget to display most booked category
class MostBookedCategoryWidget extends StatelessWidget {
  final ServiceCount mostBookedCategory;

  const MostBookedCategoryWidget({required this.mostBookedCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: mostBookedCategory.imageUrl.isNotEmpty
                ? NetworkImage(mostBookedCategory.imageUrl) // Category image
                : AssetImage('assets/default_category.png')
                    as ImageProvider, // Fallback image
          ),
          title: Text(
            mostBookedCategory.name,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle:
              Text('${mostBookedCategory.count} bookings in this category'),
          trailing: Icon(Icons.arrow_upward, color: Colors.green),
        ),
      ),
    );
  }
}

// Revenue Graph Widget
class RevenueGraph extends StatelessWidget {
  final Map<int, double> monthlyRevenue;

  RevenueGraph({required this.monthlyRevenue});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    double maxRevenue = monthlyRevenue.values.isEmpty
        ? 1000
        : monthlyRevenue.values.reduce(max);

    if (maxRevenue == 0) maxRevenue = 1000;

    monthlyRevenue.forEach((month, revenue) {
      barGroups.add(
        BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: revenue,
              color: CustomColors.primaryColor,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 2.0, offset: Offset(0, 1)),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels
              SizedBox(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    double intervalValue = (maxRevenue * (5 - index)) / 5;
                    String formattedValue = intervalValue >= 1000
                        ? '${(intervalValue / 1000).toStringAsFixed(1)}K'
                        : intervalValue.toStringAsFixed(0);
                    return Text(
                      formattedValue,
                      style: TextStyle(color: Colors.black54, fontSize: 10),
                    );
                  }),
                ),
              ),
              // Constrained bar chart with scroll
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 300,
                      width: max(constraints.maxWidth, barGroups.length * 50.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxRevenue * 1.2,
                          minY: 0,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameSize: 30,
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      months[value.toInt() - 1],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxRevenue / 5,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300]!,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.transparent),
                          ),
                          barGroups: barGroups,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bookings Graph Widget
class BookingsGraph extends StatelessWidget {
  final Map<int, int> monthlyBookings;

  BookingsGraph({required this.monthlyBookings});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    int maxBookings = monthlyBookings.values.isEmpty
        ? 10
        : monthlyBookings.values.reduce(max);

    if (maxBookings == 0) maxBookings = 10;

    monthlyBookings.forEach((month, bookings) {
      barGroups.add(
        BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: bookings.toDouble(),
              color: CustomColors.primaryColor,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, blurRadius: 2.0, offset: Offset(0, 1)),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels
              SizedBox(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    double intervalValue = (maxBookings * (5 - index)) / 5;
                    return Text(
                      intervalValue.toStringAsFixed(0),
                      style: TextStyle(color: Colors.black54, fontSize: 10),
                    );
                  }),
                ),
              ),
              // Constrained bar chart with scroll
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 300,
                      width: max(constraints.maxWidth, barGroups.length * 50.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxBookings * 1.2,
                          minY: 0,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameSize: 30,
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      months[value.toInt() - 1],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxBookings / 5,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300]!,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.transparent),
                          ),
                          barGroups: barGroups,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
