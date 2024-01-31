import 'package:catchpool/constants.dart';
import 'package:catchpool/driver/pages/driveridedetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:catchpool/components/card.dart';
import 'package:catchpool/driver/controllers/drivertrip_controller.dart';

import 'drivernavigation.dart';

class DriverRide extends StatefulWidget {
  @override
  State<DriverRide> createState() => _DriverRideState();
}

class _DriverRideState extends State<DriverRide> {
  final DriverRideController driverRideController = Get.find();

  @override
  void initState() {
    driverRideController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'Available Rides for Drivers',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
            child: Text(
              'Pending Driver Rides',
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
              if (driverRideController.pendingDriverRides.isEmpty) {
                return Center(child: Text('No pending driver rides found.'));
              }
              return ListView.builder(
                itemCount: driverRideController.pendingDriverRides.length,
                itemBuilder: (context, index) {
                  final ride = driverRideController.pendingDriverRides[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MyCard(
                      pickup: ride.pickup,
                      dropoff: ride.dropoff,
                      bookid: ride.userId,
                      date: ride.date,
                      time: ride.time,
                      pax: ride.pax ?? '',
                      status: ride.status ?? '',
                      buttonName: "View Details",// Provide a default value

                      onTap: () {
                        print(
                            'Navigating to RideDetails with ride data: $ride');
                        // Navigate to ride details page with ride data
                        // Replace RideDetails() with your driver ride details page
                        // and pass the ride data as arguments
                        Get.to(() => DriverRideDetails(), arguments: ride);
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
