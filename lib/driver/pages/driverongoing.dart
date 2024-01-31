import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/api/notification_service.dart';
import 'package:catchpool/components/drivercard.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/driver/controllers/drivertrip_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/components/my_button2.dart';
import 'package:catchpool/components/ongoingcard.dart';
import 'package:get/get.dart';

import '../../components/passengercard.dart';
import 'drivernavigation.dart';

class DriverOngoingRide extends StatefulWidget {
  @override
  _DriverOngoingRideState createState() => _DriverOngoingRideState();
}

class _DriverOngoingRideState extends State<DriverOngoingRide> {
  final DriverRideController driverRideController = Get.put(DriverRideController());

  @override
  void initState() {
    super.initState();
    driverRideController.fetchDriverOngoingRideDetailsForCurrentUser();
  }
  void refreshData() {
    setState(() {
      // Use this flag to trigger a refresh of data
      driverRideController.fetchDriverOngoingRideDetailsForCurrentUser();
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'Driver Ongoing Ride',
          style: TextStyle(fontFamily: 'Poppins', color: backgroundColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white;
                }
                return Colors.white;
              },
            ),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverNavigation()));
          },
        ),
      ),
      body: _buildDriverOngoingRideBody(),
    );
  }

  Widget _buildDriverOngoingRideBody() {
    return SingleChildScrollView(
      child: Obx(() {
        final ride = driverRideController.ride.value;

        if (ride == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 280),
              child: Text(
                'You have no ongoing ride.',
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }

        String buttonText = ''; // Initialize an empty button text
        VoidCallback? buttonAction; // Initialize a null button action

        // Determine the button text and action based on ride status
        switch (ride.status) {
          case 'Driver':
            buttonText = 'Start Ride';
            buttonAction = () {
              // Call the function to update the ride status to 'Ongoing'
              driverRideController.startRide(ride);

            };
            break;
          case 'Ongoing':
            buttonText = 'Finish Ride';
            buttonAction = () {
              // Call the function to update the ride status to 'Complete'
              driverRideController.finishRide(ride, context);

            };
            break;
          case 'Complete':
            buttonText = 'Home';
            buttonAction = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverNavigation(),
                ),
              );
            };
            break;
        }

        return Column(
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30),
                Text(
                  'Driver Ongoing Ride',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OngoingCard(
                pickup: ride.pickup,
                dropoff: ride.dropoff,
                bookid: ride.userId,
                date: ride.date,
                time: ride.time,
                price: ride.price,
                pax: ride.pax ?? "",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<String?>(
                  future: fetchPassengerFullname(ride.passengerId1!), // Pass passengerId1
                  builder: (context, passengerSnapshot1) {
                    if (passengerSnapshot1.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display loading indicator while fetching passenger data
                    } else if (passengerSnapshot1.hasError) {
                      return Text('Error: ${passengerSnapshot1.error}');
                    } else {
                      return FutureBuilder<String?>(
                        future: fetchPassengerFullname(ride.passengerId2!), // Pass passengerId2
                        builder: (context, passengerSnapshot2) {
                          if (passengerSnapshot2.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Display loading indicator while fetching passenger data
                          } else if (passengerSnapshot2.hasError) {
                            return Text('Error: ${passengerSnapshot2.error}');
                          } else {
                            return FutureBuilder<String?>(
                              future: fetchPassengerFullname(ride.passengerId3!), // Pass passengerId3
                              builder: (context, passengerSnapshot3) {
                                if (passengerSnapshot3.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Display loading indicator while fetching passenger data
                                } else if (passengerSnapshot3.hasError) {
                                  return Text('Error: ${passengerSnapshot3.error}');
                                } else {
                                  return FutureBuilder<String?>(
                                    future: fetchPassengerFullname(ride.passengerId4!), // Pass passengerId4
                                    builder: (context, passengerSnapshot4) {
                                      if (passengerSnapshot4.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Display loading indicator while fetching passenger data
                                      } else if (passengerSnapshot4.hasError) {
                                        return Text('Error: ${passengerSnapshot4.error}');
                                      } else {
                                        return PassengerCard(
                                          passengerId1: passengerSnapshot1.data ?? "",
                                          passengerId2: passengerSnapshot2.data ?? "",
                                          passengerId3: passengerSnapshot3.data ?? "",
                                          passengerId4: passengerSnapshot4.data ?? "",
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
                FutureBuilder<Map<String, dynamic>?>(
                  future: fetchDriverDetails(ride.driverId!), // Pass the driverId
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display loading indicator while fetching data
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final driverData = snapshot.data;
                      final driverName = driverData?['fullname'] ?? "";
                      final driverGender = driverData?['gender'] ?? "";
                      final driverplatecar = driverData?['platecar'] ?? "";
                      final drivercolorcar = driverData?['colorcar'] ?? "";
                      final driverbrandcar = driverData?['brandcar'] ?? "";
                      return DriverCard(
                        driverName: driverName,
                        driverGender: driverGender,
                        platecar: driverplatecar,
                        colorcar:drivercolorcar,
                        brandcar: driverbrandcar,
                      );
                    }
                  },
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MyButton2(
                    onTap: buttonAction, // Assign the button action here
                    buttonName: buttonText, // Assign the button text here
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
Future<Map<String, dynamic>?> fetchDriverDetails(String driverId) async {
  try {
    final driverDoc = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(driverId)
        .get();

    if (driverDoc.exists) {
      final driverData = driverDoc.data() as Map<String, dynamic>;
      return {
        'fullname': driverData['fullname'] ?? "",
        'gender': driverData['gender'] ?? "",
        'platecar': driverData['platecar'] ?? "",
        'colorcar': driverData['colorcar'] ?? "",
        'brandcar': driverData['brandcar'] ?? "",
      };
    } else {
      print('Driver document not found for ID: $driverId');
    }
  } catch (error) {
    print('Error fetching driver details: $error');
  }
  return null;
}

Future<String?> fetchPassengerFullname(String userId) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['fullname'] ?? ""; // Replace 'fullname' with the actual field name for the user's full name in your Firestore document
    } else {
      print('User document not found for ID: $userId');
    }
  } catch (error) {
    print('Error fetching user\'s full name: $error');
  }
  return null;
}
