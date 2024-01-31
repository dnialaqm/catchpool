
import 'package:flutter/material.dart';

class PassengerCard extends StatelessWidget {
  final String passengerId1;
  final String passengerId2;
  final String passengerId3;
  final String passengerId4;

  const PassengerCard({
    Key? key,
    required this.passengerId1,
    required this.passengerId2,
    required this.passengerId3,
    required this.passengerId4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF31403C),
            blurRadius: 4.0,
            offset: Offset(
              2.0, // Move to the right horizontally
              2.0, // Move to the bottom vertically
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passengers:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF31403C),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. " + passengerId1,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "2. " + passengerId2,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "3. " + passengerId3,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "4. " + passengerId4,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
