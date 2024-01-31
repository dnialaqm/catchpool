
import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class DriverCard extends StatelessWidget {
  final String driverName;
  final String driverGender;
  final String platecar;
  final String colorcar;
  final String brandcar;
  const DriverCard({
    Key? key,
    required this.driverName,
    required this.driverGender,
    required this.platecar,
    required this.colorcar,
    required this.brandcar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String badgeText ;
    IconData badgeIcon = Icons.boy_rounded;

    if (driverGender == 'Gender.male') {
      badgeText = 'Male';
      badgeIcon = Icons.boy_rounded;
    }
    if (driverGender == 'Gender.female') {
      badgeText = 'Female';
      badgeIcon = Icons.girl_rounded;
    }
    else {
      badgeText = 'O';

    }

    return Container(

      decoration: BoxDecoration(
        color: Color(0xFF383736),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Move this line here

              children: [
                Text(
                  'Driver:',
                  style: TextStyle(
                    fontSize: 14,
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Text(
                            driverName,
                            style: TextStyle(
                              fontSize: 10,
                              color: backgroundColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        badges.Badge(
                          position:
                              badges.BadgePosition.topEnd(top: -10, end: -20),
                          badgeContent: Text(
                            badgeText,
                            style:
                                TextStyle(fontSize: 10), // Adjust the font size
                          ),

                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.square,
                            badgeColor: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Move this line here

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Details:',
                      style: TextStyle(
                        fontSize: 12,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Plate No: ' + platecar,
                      style: TextStyle(
                        fontSize: 10,
                        color: backgroundColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Car Color: ' +colorcar,
                      style: TextStyle(
                        fontSize: 10,
                        color: backgroundColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Car Type: ' +brandcar,
                      style: TextStyle(
                        fontSize: 10,
                        color: backgroundColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

        ),
      ),
    );
  }
}
