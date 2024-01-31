import 'package:flutter/material.dart';

import '../constants.dart';

void main() {
  runApp(MaterialApp(
    home: Intro1(), // Initial page
  ));
}

class Intro1 extends StatelessWidget {
  final PageController controller = PageController();

  Intro1({super.key}); // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/photo1.png', height: 300.0),
            const Text(
              'Hassle-Free Ride Scheduling',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryLightColor,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Easily schedule and order rides at your preferred time and location. Say goodbye to waiting and hello to efficient planning.',
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.justify,

            ),
            // Add more widgets or functionality here
            // For example, you might want to add buttons or navigation
          ],
        ),
      ),
    );
  }
}
