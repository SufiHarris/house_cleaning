// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class PushNotifications {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // request notification permission
//   static Future init() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: false,
//       criticalAlert: true,
//       provisional: false,
//       sound: true,
//     );

//     // get the device fcm token
//     final token = await _firebaseMessaging.getToken();
//     print("for android device token: $token");
//   }

//   // initalize local notifications
//   static Future localNotiInit() async {
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       onDidReceiveLocalNotification: (id, title, body, payload) => null,
//     );
//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsDarwin,
//             linux: initializationSettingsLinux);

//     // request notification permissions for android 13 or above
//     _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .requestNotificationsPermission();

//     _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onNotificationTap,
//         onDidReceiveBackgroundNotificationResponse: onNotificationTap);
//   }

//   // on tap local notification in foreground
//   static void onNotificationTap(NotificationResponse notificationResponse) {}
// }

// lib/notifications/notifications.dart
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http; // for making HTTP requests

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String projectId =
      '550265053132'; // Replace with your Firebase Project ID
  static const String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  // Service account details
  static const String serviceAccountPath =
      ' '; // Path to your service account JSON file

  // List of FCM tokens to which the notification will be sent
  static const List<String> _userTokens = [
    "dD_v8C7KRgqXgMmbSdZkDw:APA91bGgQxolgg9zEvA179uUs5AdsZRlFisoAYSlO1m91dSP7eIcclbzwBVETr6U0o39UOAGj1jEJ0CMqDBVEIV2ett50b_ore-ox1xRTBUNsiY2V9OisqNp_kHzhwNOgYSj7BWrdLQK"
  ];

  // Initialize Firebase Messaging and request notification permission
  static Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Set up background message handling
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  }

  // Initialize local notifications
  static Future<void> localNotiInit() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Request permission for Android 13+
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    // Initialize local notifications plugin
    _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );
  }

  // Handle background messages (top-level function)
  static Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print("Background Notification Received: ${message.notification!.body}");
    }
  }

  // Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      print("Foreground Notification: ${message.notification!.title}");
      _showLocalNotification(message);
    }
  }

  // Show local notification when a foreground FCM message is received
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
    );
  }

  // Send notification to users using FCM v1 API
  static Future<void> sendNotificationToUsers(String title, String body) async {
    // Load the service account credentials
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await File(serviceAccountPath).readAsString(),
    );

    // Get OAuth 2.0 token
    final authClient = await clientViaServiceAccount(
      accountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    // Prepare the payload (JSON format)
    final payload = {
      "message": {
        "notification": {
          "title": title,
          "body": body,
        },
        "token":
            "dD_v8C7KRgqXgMmbSdZkDw:APA91bGgQxolgg9zEvA179uUs5AdsZRlFisoAYSlO1m91dSP7eIcclbzwBVETr6U0o39UOAGj1jEJ0CMqDBVEIV2ett50b_ore-ox1xRTBUNsiY2V9OisqNp_kHzhwNOgYSj7BWrdLQK", // Replace with the user's FCM token
      },
    };

    // Send the HTTP POST request with OAuth token
    final response = await authClient.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    // Handle the response
    if (response.statusCode == 200) {
      print("Notification sent successfully!");
    } else {
      print("Failed to send notification: ${response.body}");
    }

    authClient.close(); // Close the auth client
  }

  // Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    print("Notification tapped: ${message.notification?.title}");
    // You can navigate to a specific screen here if needed
  }

  // Handle local notification tap
  static void _onNotificationTap(NotificationResponse response) {
    print("Local notification tapped with payload: ${response.payload}");
    // Handle navigation or other actions on tap
  }
}
