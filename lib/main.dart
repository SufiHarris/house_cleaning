import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/screeens/admin_main.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/auth/screens/auth_screen.dart';
import 'package:house_cleaning/employee/screens/employee_home.dart';
import 'package:house_cleaning/notifications/notifications.dart';
import 'package:house_cleaning/user/screens/user_main.dart';
import 'admin/provider/admin_provider.dart';
import 'employee/provider/employee_provider.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/custom_theme.dart';
import 'tracking/tracking_controller.dart';
import 'user/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Messaging and Local Notifications
  await PushNotifications.init();

  // Initialize local notifications
  await PushNotifications.localNotiInit();

  // Register dependencies using GetX
  Get.put(AuthProvider());
  Get.put(UserProvider());
  Get.put(EmployeeTrackingController());
  Get.put(EmployeeProvider());
  Get.put(AdminProvider());

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
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        home: Obx(() {
          final authProvider = Get.find<AuthProvider>();

          // Check both authentication and user type
          if (authProvider.isUserAuthenticated()) {
            // If user type is known, use it for navigation
            if (authProvider.userType.value.isNotEmpty) {
              switch (authProvider.userType.value) {
                case 'admin':
                  return AdminMain();
                case 'staff':
                  return const EmployeeHome();
                case 'user':
                  return const UserMain();
                default:
                  return const AuthScreen();
              }
            }
            // If no user type is stored but user is authenticated,
            // show loading or return to auth screen
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const AuthScreen();
        }),
      ),
    );
  }
}
