import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth/provider/auth_provider.dart';
import 'auth/screens/auth_screen.dart';
import 'theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthProvider());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.themeData,
      home: const AuthScreen(),
    ));
  }
}
