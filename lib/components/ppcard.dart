import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';

class PPCard extends StatelessWidget {
  final String price;
  final String pax;
  final double cardWidth = 150.0; // Define the card width here (reduced)
  final double cardHeight = 120.0; // Define the card height here (reduced)

  const PPCard({
    Key? key,
    required this.price,
    required this.pax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    Icons.money,
                    color: backgroundColor, // Change icon color
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "RM",
                        style: TextStyle(
                          fontSize: 17,
                          color: backgroundColor, // Change text color
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 17,
                          color: backgroundColor, // Change text color
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
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
                    Icons.person,
                    color: backgroundColor, // Change icon color
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pax,
                        style: TextStyle(
                          fontSize: 17,
                          color: backgroundColor, // Change text color
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "/4",
                        style: TextStyle(
                          fontSize: 17,
                          color: kPrimaryColor, // Change text color
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
