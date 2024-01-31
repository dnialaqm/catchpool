import 'package:catchpool/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import 'register.dart';

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/images/photo3.png', height: 300.0),
              const Text(
                'Enhancing Community & Reducing Traffic',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryLightColor,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'By sharing rides with fellow students or theme park visitors, you\'re not just saving money but also reducing traffic congestion and contributing to a greener environment.',
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const Login());
                },
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryLightColor,
                  onPrimary: backgroundColor,
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, right: 40, left: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
