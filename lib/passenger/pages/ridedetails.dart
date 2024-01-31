import 'package:catchpool/components/dtcard.dart';
import 'package:catchpool/components/locationcard.dart';
import 'package:catchpool/components/my_button2.dart';
import 'package:catchpool/components/ppcard.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/passenger/controllers/addtrip_controller.dart';
import 'package:catchpool/passenger/pages/ride.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:catchpool/passenger/models/ride_model.dart'; // Import RideModel

class RideDetails extends StatelessWidget {
  final AddRideController addRideController = Get.put(AddRideController());

  @override
  Widget build(BuildContext context) {
    // Access the argument using Get.arguments
    if (Get.arguments is RideModel) {
      // Cast Get.arguments to RideModel
      final RideModel ride = Get.arguments as RideModel;
      // Handle the case where Get.arguments is not of type RideModel

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: kPrimaryLightColor,
          title: Text(
            'Ride Details Page',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            style: ButtonStyle(
              // Use MaterialStateProperty.resolveWith to handle different states
              foregroundColor: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
                  // Use a different color for pressed state if needed
                  if (states.contains(MaterialState.pressed)) {
                    return Colors
                        .white; // Change this to the desired pressed color
                  }
                  // Return the default color for other states
                  return Colors.white;
                },
              ),
            ),
            onPressed: () {
              Get.offAll(() => Ride());
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
              child: Text(
                'Ride Details',
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LocationCard(
                        pickup: '${ride.pickup ?? ''}',
                        dropoff: '${ride.dropoff ?? ''}'),
                    const SizedBox(height: 10),
                    DTCard(
                        date: '${ride.date ?? ''}', time: '${ride.time ?? ''}'),
                    PPCard(
                        pax: '${ride.pax ?? ''}', price: '${ride.price ?? ''}'),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 183),
                      child: MyButton2(
                        onTap: () {
                          final rideId = ride.id ?? '';
                          addRideController.joinRide(context,rideId);
                        },
                        buttonName: "Join Ride",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Handle the case where Get.arguments is not of type RideModel
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid argument type for RideModel'),
        ),
      );
    }
  }
}
