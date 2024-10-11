import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/auth/screens/auth_screen.dart';
import 'package:house_cleaning/user/screens/user_main.dart';

import 'firebase_options.dart';
import 'theme/custom_theme.dart';
import 'user/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(
    AuthProvider(),
  );

  Get.put(
    UserProvider(),
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.themeData,
        home: Obx(() {
          final authProvider = Get.find<AuthProvider>();
          return authProvider.user.value != null
              ? const UserMain()
              : AuthScreen();
        }),
      ),
    );
  }
}
