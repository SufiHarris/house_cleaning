import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/screens/employee_home.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

import '../../generated/l10n.dart';

class OrderOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.textColorThree),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          S.of(context).orderOverview,
          style: TextStyle(
            color: CustomColors.textColorThree,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 70),
                decoration: BoxDecoration(
                  color: Color(0xFFD9CDBA),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: CustomColors.textColorThree,
                      child: Icon(Icons.local_laundry_service,
                          size: 30.0, color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      S.of(context).greatJob,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      S.of(context).serviceCompletedSuccessfully,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: CustomColors.textColorThree,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: CustomColors.textColorThree),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
              ),
              onPressed: () {
                Get.to(() => EmployeeHome());
              },
              child: Text(
                S.of(context).backToHome,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
