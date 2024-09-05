import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/provider/auth_provider.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  authProvider.signOut();
                },
                child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
