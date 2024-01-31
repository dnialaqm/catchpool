import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/components/my_button.dart';
import 'package:catchpool/components/my_textfield.dart';
import 'package:catchpool/passenger/controllers/addtrip_controller.dart';

import '../../driver/controllers/drivertrip_controller.dart';

class DriverAddRide extends StatelessWidget {
  DriverAddRide({Key? key}) : super(key: key);
  final DriverRideController drivecontroller =
  DriverRideController(); // In
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'Add Ride - Driver',
          style: TextStyle(fontFamily: 'Poppins', color: backgroundColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),

                    // LOGO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_car,
                          color: kPrimaryLightColor,
                          size: 100,
                        ),
                        const Icon(
                          Icons.plus_one,
                          color: kPrimaryLightColor,
                          size: 40,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add New Ride',
                          style: TextStyle(
                            color: kPrimaryLightColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    MyTextField(
                      controller: drivecontroller.usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: drivecontroller.pickupController,
                      hintText: 'Pick-Up Location',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: drivecontroller.dropoffController,
                      hintText: 'Drop-Off Location',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: drivecontroller.dateController,
                      hintText: 'Date',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    MyTextField(
                      controller: drivecontroller.timeController,
                      hintText: 'Time',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),
                    MyTextField(
                      controller: drivecontroller.priceController,
                      hintText: 'Price',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    MyButton(
                      onTap: () => drivecontroller.driverAddRide(),
                      buttonName: 'Add Ride',
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
