import '../constants.dart';
import 'slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Splash(), // Your initial page
  ));
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () {
          // Navigate to the next page here
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SplashPage()));
        },
        child:  SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                Column(
                  children: [
                    Image.asset('assets/images/CatchPool.png', height: 300.0),
                    Text(
                      "Welcome, to",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "CatchPool!",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryLightColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "Your Safe & Convenient Carpooling Solution!",
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
