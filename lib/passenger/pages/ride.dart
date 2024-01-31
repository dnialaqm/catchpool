import 'package:catchpool/constants.dart';
import 'package:catchpool/passenger/pages/ridedetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:catchpool/components/card.dart';
import 'package:catchpool/passenger/controllers/addtrip_controller.dart';
import 'package:catchpool/passenger/pages/navigation.dart';

class Ride extends StatefulWidget {
  @override
  State<Ride> createState() => _RideState();
}

class _RideState extends State<Ride> {
  final AddRideController addRideController = Get.find();

  @override
  void initState() {
    addRideController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'Join Available Ride',
          style: TextStyle(fontFamily: 'Poppins', color: backgroundColor),
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
                  return backgroundColor; // Change this to the desired pressed color
                }
                // Return the default color for other states
                return backgroundColor;
              },
            ),
          ),
          onPressed: () {
            Get.offAll(() => Navigation());
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
            child: Text(
              'Available Rides',
              style: TextStyle(
                color: kPrimaryLightColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (addRideController.availableRides.isEmpty) {
                return Center(child: Text('No available rides found.'));
              }
              return ListView.builder(
                itemCount: addRideController.availableRides.length,
                itemBuilder: (context, index) {
                  final ride = addRideController.availableRides[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MyCard(
                      pickup: ride.pickup,
                      dropoff: ride.dropoff,
                      bookid: ride.userId,
                      date: ride.date,
                      time: ride.time,
                      pax: ride.pax ?? "0",
                      status: ride.status ??
                          "",
                          buttonName: "View Details",// Provide a default value
                      onTap: () {
                        print(
                            'Navigating to RideDetails with ride data: $ride');
                        Get.to(() => RideDetails(), arguments: ride);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
