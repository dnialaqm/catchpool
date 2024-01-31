import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/constants.dart'; // Import your constants
import 'package:catchpool/passenger/pages/history.dart'; // Import your constants

import '../../driver/controllers/drivertrip_controller.dart';
import '../models/ride_model.dart'; // Import Firebase Firestore

class CompleteRidePopup extends StatefulWidget {
  final VoidCallback onClose;
  final RideModel ride;

  CompleteRidePopup({required this.onClose, required this.ride});

  @override
  State<CompleteRidePopup> createState() => _CompleteRidePopupState();
}

class _CompleteRidePopupState extends State<CompleteRidePopup> {
  final user = FirebaseAuth.instance.currentUser!;
  DriverRideController driverRideController = DriverRideController();

  String? fullname;

  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        fullname = userData['fullname'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: widget.onClose,
              icon: Icon(
                Icons.close,
                color: kPrimaryColor,
                size: 30.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Congratulations ${fullname ?? 'Guest'}, You have completed your ride. Have a nice day!",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins',
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => History(),
                  ),
                );
              },
              child: Text(
                "Go to History",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
