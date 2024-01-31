import 'package:catchpool/constants.dart';
import 'package:catchpool/driver/controllers/driverprofile_controller.dart';
import 'package:catchpool/driver/pages/driverride.dart';
import 'package:catchpool/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/passenger/pages/addtrip.dart';
import 'package:get/get.dart';

import 'driveraddtrip.dart';

class DriverHome extends StatefulWidget {
  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final DriverProfileController driverProfileController =
      Get.put(DriverProfileController());

  final user = FirebaseAuth.instance.currentUser!;
  String? fullname;
  String? gender; // Store user's gender

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("Drivers")
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        fullname = userData['fullname'];
      });
    }
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Get.to(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => signUserOut(), icon: Icon(Icons.logout),
          color: backgroundColor,)
        ],
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'CatchPool - Driver',
          style: TextStyle(fontFamily: 'Poppins', color: backgroundColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            FutureBuilder<String?>(
              future: fetchDriverGender(), // Replace with your function to fetch user's gender
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Display loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final gender = snapshot.data;

                  if (gender == 'Gender.male') // Display profile icon based on gender
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: textColor, // Change border color as desired
                          width: 2.0, ),
                      ),// Adjust border width as desired
                      // Adjust border width as desired
                      child: CircleAvatar(
                        backgroundColor: kPrimaryColor, // Change background color as desired
                        radius: 40,
                        child: Icon(
                          Icons.face,
                          size: 45, // Adjust the icon size as desired
                          color: textColor, // Change icon color as desired
                        ),
                      ),
                    );
                  else if (gender == 'Gender.female')
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kPrimaryLightColor, // Change border color as desired
                          width: 2.0, ),
                      ),// A
                      child: CircleAvatar(
                        backgroundColor: kPrimarySecondaryColor, // Change background color as desired
                        radius: 40,
                        child: Icon(
                          Icons.face_3,
                          size: 45, // Adjust the icon size as desired
                          color: textColor, // Change icon color as desired
                        ),
                      ),
                    );
                  else
                    return SizedBox(); // Handle other cases or return an empty container
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Hello, ${fullname ?? 'Guest'}", // Replace with the user's name
                  style: const TextStyle(
                    fontSize: 25,
                    color: textColor,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(

                  "Give a ride today :)",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryLightColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: kPrimaryLightColor,// Add your desired border color here
                        width: 1.0,
                      ),
                    ),
                    elevation: 10, // Add box shadow elevation
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 210,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Drive Hassle-Free',
                            style: TextStyle(
                              fontSize: 15,
                              color: kPrimaryLightColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverAddRide(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryLightColor,
                              onPrimary: backgroundColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 40,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.add_circle_outline_rounded),
                                SizedBox(height: 10),
                                Text(
                                  "Set a Ride",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: backgroundColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await driverProfileController.fetchDriverData(
                                  driverProfileController.currentUser.uid);

                              if (driverProfileController
                                      .driverModel.value.verification ==
                                  "Unverified") {
                                // Show the verification alert if verification is "unverified"
                                driverProfileController
                                    .showVerificationAlert(context);
                              } else {
                                // Navigate to the AddRide page if verification is not "unverified"
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DriverRide(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryLightColor,
                              onPrimary: backgroundColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 40,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.airport_shuttle_rounded),
                                SizedBox(height: 10),
                                Text(
                                  "View Rides",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: backgroundColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Future<String?> fetchDriverGender() async {
  try {
    final currentDriver = FirebaseAuth.instance.currentUser;
    if (currentDriver == null) {
      return null; // Handle the case where the user is not authenticated
    }

    final id = currentDriver.uid;
    final driverDoc = await FirebaseFirestore.instance
        .collection("Drivers")
        .doc(id)
        .get();

    if (driverDoc.exists) {
      final driverData = driverDoc.data() as Map<String, dynamic>;
      return driverData['gender'] ?? ""; // Replace 'gender' with the actual field name for the user's gender in your Firestore document
    } else {
      print('User document not found for ID: $id');
    }
  } catch (error) {
    print('Error fetching user\'s gender: $error');
  }
  return null;
}
