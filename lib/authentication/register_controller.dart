import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/passenger/models/user_model.dart';
import 'package:catchpool/driver/models/driver_model.dart';
import 'package:catchpool/authentication/login.dart';
import 'package:catchpool/driver/pages/drivernavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/notification_service.dart';
import '../passenger/pages/navigation.dart';
import 'register.dart';

class RegisterController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController studentNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    TextEditingController driverlicenseController = TextEditingController();
  TextEditingController platecarController = TextEditingController();
  TextEditingController colorcarController = TextEditingController();
  TextEditingController brandcarController = TextEditingController();
  TextEditingController verificationController = TextEditingController();
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  Gender? selectedGender = Gender.male; // Set default gender
  String? selectedUserType = 'Passenger';

  Future<UserCredential> signUserUp() async {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAll(() => Navigation());
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close the dialog
      throw e.code;
      // showErrorMessage(e.code);
    }
  }

void saveUserData() async {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    final userCredential = await signUserUp();
    
    if (selectedUserType == 'Passenger') {
      // Create a UserModel for passengers
      final newUser = UserModel(
        id: userCredential.user!.uid,
        username: usernameController.text.trim(),
        fullname: fullnameController.text.trim(),
        phone: phoneController.text.trim(),
        studentNo: studentNoController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userType: selectedUserType ?? "DefaultUserType",
        gender: selectedGender?.toString() ?? "DefaultGender",
      );

      // Save the user data to the "Users" collection
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());
      await NotificationService.showNotification(
        title: "Successfully Registered",
        body: "Hello, Welcome to CatchPool!",
        summary: "CatchPool",
        notificationLayout: NotificationLayout.Default,
      );
              Get.offAll(() => Navigation());

    } else if (selectedUserType == 'Driver') {
      // Create a DriverModel for drivers
      final newDriver = DriverModel(
        id: userCredential.user!.uid,
        username: usernameController.text.trim(),
        fullname: fullnameController.text.trim(),
        phone: phoneController.text.trim(),
        studentNo: studentNoController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userType: selectedUserType ?? "DefaultUserType",
        gender: selectedGender?.toString() ?? "DefaultGender",
        driverlicense: "",
        platecar: "",
        colorcar: "",
        brandcar: "",
        verification: "Unverified",
      );

      // Save the driver data to the "Drivers" collection
      await FirebaseFirestore.instance
          .collection("Drivers")
          .doc(userCredential.user!.uid)
          .set(newDriver.toJson());
      await NotificationService.showNotification(
        title: "Successfully Registered",
        body: "Hello, Welcome to CatchPool!",
        summary: "CatchPool",
        notificationLayout: NotificationLayout.Default,
      );
              Get.offAll(() => DriverNavigation());

    }

  } on FirebaseAuthException catch (e) {
    Get.back(); // Close the dialog
    showErrorMessage(e.code);
  }
}


  void showErrorMessage(String message) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF99DDCC),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: const Color(0xFF99DDCC),
          title: Text(
            'Incorrect Password',
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }
}