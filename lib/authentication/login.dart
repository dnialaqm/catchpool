import 'dart:async'; // Import for Timer
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/components/square_tile.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/driver/pages/drivernavigation.dart';
import '../api/notification_service.dart';
import 'register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/components/my_button.dart';
import 'package:catchpool/components/my_textfield.dart';
import 'package:catchpool/passenger/pages/navigation.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _retryFunction(Future<void> Function() operation) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        await operation();
        return;
      } catch (e) {
        if (e.toString().contains('cloud_firestore/unavailable')) {
          await Future.delayed(retryDelay);
          retryCount++;
        } else {
          print('Error: $e');
          break;
        }
      }
    }

    if (retryCount == maxRetries) {
      print('Maximum retries reached. Firestore still unavailable.');
    }
  }

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      Future<void> loginOperation() async {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final userId = userCredential.user!.uid;

        final driverDoc = await FirebaseFirestore.instance
            .collection("Drivers")
            .doc(userId)
            .get();

        if (driverDoc.exists) {
          final userData = driverDoc.data() as Map<String, dynamic>;
          final userType = userData['userType'] as String?;
          Navigator.pop(context);

          if (userType == 'Driver') {
            Get.offAll(() => DriverNavigation());
            await NotificationService.showNotification(
              title: "Successfully Logged In",
              body: "Hello Driver' - Happy 'CatchPool'ing!",
              summary: "CatchPool",
              notificationLayout: NotificationLayout.Default,
            );
            return;
          }
        }

        final userDoc = await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userType = userData['userType'] as String?;
          Navigator.pop(context);

          if (userType == 'Passenger') {
            Get.offAll(() => Navigation());
            await NotificationService.showNotification(
              title: "Successfully Logged In",
              body: "Hello Passenger' - Happy 'CatchPool'ing!",
              summary: "CatchPool",
              notificationLayout: NotificationLayout.Default,
            );
            return;
          }
        }
      }

      await _retryFunction(loginOperation);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const  Color(0xFFC4AE78),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color:Color(0xFF60624E)),
            ),
          ),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
            backgroundColor: Color(0xFFC4AE78),
            title: Text(
              'Incorrect Password',
              style: TextStyle(color: Color(0xFF60624E)),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EEED),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: GlobalKey<FormState>(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),

                    // LOGO
                    const Icon(
                      Icons.lock,
                      color:  kPrimaryLightColor,
                      size: 100,
                    ),

                    const SizedBox(height: 25),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color:  kPrimaryLightColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, You\'ve been missed!',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.grey[600], fontFamily: 'Poppins'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    MyButton(
                      onTap: () => signUserIn(),
                      buttonName: 'Log In',
                    ),

                    const SizedBox(height: 30),


                    const SizedBox(height: 50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member?',
                          style: TextStyle(color: textColor),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const Register());
                          },
                          child: const Text('Register Now!',
                              style: TextStyle(
                                color:Color(0xFFC4AE78),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
