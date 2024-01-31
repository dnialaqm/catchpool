import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/components/my_button.dart';
import 'package:catchpool/components/my_textfield.dart';
import 'package:catchpool/passenger/controllers/addtrip_controller.dart';

import '../../driver/controllers/drivertrip_controller.dart';

class AddRide extends StatelessWidget {
  AddRide({Key? key}) : super(key: key);
  final AddRideController controller =
      AddRideController(); // Instantiate the controller

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'Add Ride',
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
                      controller: controller.usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: controller.pickupController,
                      hintText: 'Pick-Up Location',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: controller.dropoffController,
                      hintText: 'Drop-Off Location',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // TEXTBOX
                    MyTextField(
                      controller: controller.dateController,
                      hintText: 'Date',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    MyTextField(
                      controller: controller.timeController,
                      hintText: 'Time',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),
                    MyTextField(
                      controller: controller.priceController,
                      hintText: 'Price',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    MyButton(
                      onTap: () => controller.addRide(),
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
