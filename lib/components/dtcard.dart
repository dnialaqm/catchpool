import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';

class DTCard extends StatelessWidget {
  final String date;
  final String time;
  final double cardWidth = 150.0; // Define the card width here (reduced)
  final double cardHeight = 120.0; // Define the card height here (reduced)

  const DTCard({
    Key? key,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              color: kPrimaryLightColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: backgroundColor, // Change icon color to backgroundColor
                    ),
                    SizedBox(height: 10),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 17,
                        color: backgroundColor,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              color: kPrimaryLightColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_clock,
                      color: backgroundColor, // Change icon color to backgroundColor
                    ),
                    SizedBox(height: 10),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 17,
                        color: backgroundColor,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
