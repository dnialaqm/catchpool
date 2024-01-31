import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/components/historycard.dart';
import 'package:get/get.dart';
import 'package:catchpool/driver/controllers/driverhistory_controller.dart'; // Import the driver's history controller

void main() {
  runApp(MaterialApp(
    home: DriverHistory(),
  ));
}

class DriverHistory extends StatefulWidget {
  @override
  State<DriverHistory> createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
  final DriverHistoryController driverhistoryController = Get.find();
  void initState() {
    driverhistoryController.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'Past Given Rides - Driver',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 30),
              Text(
                'History',
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (driverhistoryController.completedDriverRides.isEmpty) {
                return Center(
                  child: Text(
                    'No completed rides found.',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemCount: driverhistoryController.completedDriverRides.length,
                itemBuilder: (context, index) {
                  final ride = driverhistoryController.completedDriverRides[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HistoryCard(
                      pickup: ride.pickup,
                      dropoff: ride.dropoff,
                      bookid: ride.id!.substring(ride.id!.length - 4), // Show last four digits of user ID
                      date: ride.date,
                      time: ride.time,
                      pax: ride.pax ?? "",
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
