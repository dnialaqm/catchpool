import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/api/firebase_api.dart';
import 'package:catchpool/passenger/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/authentication/login.dart';
import 'package:catchpool/authentication/login.dart';
import 'package:catchpool/passenger/controllers/ongoingride_controller.dart';
import 'package:catchpool/passenger/controllers/addtrip_controller.dart';
import 'package:catchpool/driver/controllers/drivertrip_controller.dart';
import 'package:catchpool/authentication/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'api/notification_service.dart';
import 'authentication/splash.dart';
import 'driver/controllers/driverhistory_controller.dart';
import 'firebase_options.dart';
import 'package:catchpool/passenger/controllers/history_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await FirebaseApi().initNotifications();

  await NotificationService.initializeNotification();
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddRideController());
    Get.put(OngoingRideController());
    Get.put(DriverRideController());
    Get.put(DriverHistoryController());
    Get.put(HistoryController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatchPool_App',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: Splash(),
    );
  }
}
