import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/employee/widgets/employee_card.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';
import '../../theme/custom_colors.dart';
import '../../user/providers/user_provider.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();
    final authProvider = Get.find<AuthProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        child: SvgPicture.asset("assets/images/logo.svg"),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: CustomColors.textColorFour),
                          ),
                          FutureBuilder<UserModel?>(
                            future: getUserDetailsFromLocal(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading...",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: CustomColors.textColorTwo));
                              }
                              return Text(
                                snapshot.data?.name ?? "User",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: CustomColors.textColorTwo),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      authProvider.signOut();
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/images/icon_bell.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Employee Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: EmployeeCard(
                name: "haris",
                imageUrl:
                    "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                number: 9988776655,
                experience: '4 years',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),

            // Tab Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  HeadingText(headingText: "Assigned task"),
                  TabBar(
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Text('3'),
                            ),
                            SizedBox(width: 8),
                            Text('Assigned'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Text('0'),
                            ),
                            SizedBox(width: 8),
                            Text('Unassigned'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                children: [
                  // Assigned Tasks
                  ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      _buildTaskItem(
                        "Apartment Cleaning",
                        "04:20 PM",
                        "assets/images/apartment_icon.svg",
                      ),
                      _buildTaskItem(
                        "Furniture Cleaning",
                        "05:00 PM",
                        "assets/images/furniture_icon.svg",
                      ),
                      _buildTaskItem(
                        "Facades Cleaning",
                        "06:10 PM",
                        "assets/images/facades_icon.svg",
                      ),
                    ],
                  ),
                  // Unassigned Tasks
                  Center(child: Text("No unassigned tasks")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, String time, String iconPath) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: SvgPicture.asset(iconPath, width: 40, height: 40),
        title: Text(title),
        subtitle: Row(
          children: [
            Icon(Icons.access_time, size: 16),
            SizedBox(width: 4),
            Text(time),
          ],
        ),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
