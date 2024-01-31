import 'package:flutter/material.dart';

import '../constants.dart';

class Intro2 extends StatelessWidget {
  const Intro2({super.key});

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
              Image.asset('assets/images/photo2.png', height: 300.0),
              const Text(
                'Gender-Specific Rides for Safety',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryLightColor,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'We prioritize your safety. Choose to ride with individuals of the same gender to ensure comfort and peace of mind during your journeys.',
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
