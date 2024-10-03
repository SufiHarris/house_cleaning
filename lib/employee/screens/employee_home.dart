import 'package:flutter/material.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            AuthProvider().signOut();
          },
          child: Text("log out ")),
    );
  }
}
