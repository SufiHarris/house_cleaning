import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/auth/screens/auth_screen.dart';
import 'package:house_cleaning/notifications/notification_class.dart';
import 'package:house_cleaning/notifications/notifications.dart';
import 'package:house_cleaning/user/screens/user_main.dart';

import 'admin/provider/admin_provider.dart';
import 'employee/provider/employee_provider.dart';
import 'firebase_options.dart';
import 'general_functions/user_profile_image.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/custom_theme.dart';
import 'tracking/tracking_controller.dart';
import 'user/providers/user_provider.dart';

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received in background...");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // NotificationService().initNotification();
  // initialize firebase messaging
  await PushNotifications.init();
  await PushNotifications.localNotiInit();

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  Get.put(
    AuthProvider(),
  );

  Get.put(
    UserProvider(),
  );

  Get.put(
    EmployeeTrackingController(),
  );

  Get.put(
    EmployeeProvider(),
  );
  Get.put(
    AdminProvider(),
  );
  Get.put(ImageController());
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
        localizationsDelegates: const [
          S.delegate, // Ensure this matches the generated localization delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
        ],
        // locale: _currentLocale, // T
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
