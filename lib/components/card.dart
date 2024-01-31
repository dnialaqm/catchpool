
import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String bookid;
  final String date;
  final String time;
  final String pax;
  final String status;
  final String buttonName;

  final Function()? onTap;

  const MyCard({
    Key? key,
    required this.pickup,
    required this.dropoff,
    required this.bookid,
    required this.date,
    required this.time,
    required this.pax,
    required this.status,
    required this.onTap,
        required this.buttonName,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    pickup,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(), // Add this Spacer widget
                Badge(
                  label: Text(
                      status == 'Driver' ? 'Driver' : 'Pending Driver'),
                  textColor:
                      status == 'Driver' ? kPrimarySecondaryColor : kPrimaryLightColor,
                  backgroundColor: kPrimaryLightColor.withOpacity(0.2),
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    dropoff,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
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
                    color: Color(0xFF31403C),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '  -  ',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF31403C),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  pax,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  ' seats',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryLightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    child: Text(
                      buttonName,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
