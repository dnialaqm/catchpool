
import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';

class OngoingCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String bookid;
  final String date;
  final String time;
  final String pax;
  final String price;

  const OngoingCard({
    Key? key,
    required this.pickup,
    required this.dropoff,
    required this.bookid,
    required this.date,
    required this.time,
    required this.price,
    required this.pax,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
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
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'From:',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    pickup,
                    style: TextStyle(
                      fontSize: 17,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(), // Add this Spacer widget
                Text(
                  pax,
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' seats',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end, // Move this line here
            ),

            Row(
              children: [
                Text(
                  'To:',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    dropoff,
                    style: TextStyle(
                      fontSize: 17,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),

            // time
            Row(
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '  -  ',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),

            Text(
              "Fare: RM" + price,
              style: TextStyle(
                fontSize: 17,
                color: textColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
