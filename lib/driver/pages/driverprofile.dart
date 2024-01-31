import 'package:catchpool/components/my_textbox.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/driver/controllers/driverprofile_controller.dart';
import 'package:catchpool/passenger/pages/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'drivernavigation.dart';

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({Key? key}) : super(key: key);

  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage>
    with SingleTickerProviderStateMixin {
  final DriverProfileController driverProfileController =
      Get.put(DriverProfileController());

  late TabController _tabController;
  //final currentUser = FirebaseAuth.instance.currentUser!;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? gender; // Store user's gender

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    await driverProfileController
        .fetchDriverData(driverProfileController.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'My Profile - Driver',
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
                  return Colors
                      .white; // Change this to the desired pressed color
                }
                // Return the default color for other states
                return Colors.white;
              },
            ),
          ),
          onPressed: () {
            Get.offAll(() => DriverNavigation());
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot?>(
        stream: driverProfileController.driverData.stream,
        builder: (context, snapshot) {
          // Check if data is available and not null
          if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot.data!.data()! as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: kPrimaryLightColor,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
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
                  Obx(
                    () => Text(
                      driverProfileController.driverModel.value.fullname,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kPrimaryLightColor),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: kPrimaryColor,
                    unselectedLabelColor: textColor,
                    tabs: [
                      Tab(text: 'Personal Info'),
                      Tab(text: "Driver's Info"),
                    ],
                  ),
                  SizedBox(
                    height: 900, // Adjust the height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Profile Tab
                        Column(
                          children: [
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['fullname'] ??
                                  '',
                              sectionName: 'Fullname',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'fullname',
                                      driverProfileController
                                              .driverData.value?['fullname'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['username'] ??
                                  '',
                              sectionName: 'Username',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'username',
                                      driverProfileController
                                              .driverData.value?['username'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['phone'] ??
                                  '',
                              sectionName: 'Phone',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'phone',
                                      driverProfileController
                                              .driverData.value?['phone'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['studentNo'] ??
                                  '',
                              sectionName: 'Student No',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'studentNo',
                                      driverProfileController
                                              .driverData.value?['studentNo'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['gender'] ??
                                  '',
                              sectionName: 'Gender',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'gender',
                                      driverProfileController
                                              .driverData.value?['gender'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['userType'] ??
                                  '',
                              sectionName: 'User Type',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'userType',
                                      driverProfileController
                                              .driverData.value?['userType'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['email'] ??
                                  '',
                              sectionName: 'Email',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'email',
                                      driverProfileController
                                              .driverData.value?['email'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['password'] ??
                                  '',
                              sectionName: 'Password',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'password',
                                      driverProfileController
                                              .driverData.value?['password'] ??
                                          ''),
                            ),
                          ],
                        ),

                        // Driver's Info Tab
                        Column(
                          children: [
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['driverlicense'] ??
                                  '',
                              sectionName: 'Driver License',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'driverlicense',
                                      driverProfileController.driverData
                                              .value?['driverlicense'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['brandcar'] ??
                                  '',
                              sectionName: 'Brand Car',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'brandcar',
                                      driverProfileController
                                              .driverData.value?['brandcar'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['platecar'] ??
                                  '',
                              sectionName: 'Plate No',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'platecar',
                                      driverProfileController
                                              .driverData.value?['platecar'] ??
                                          ''),
                            ),
                            MyTextBox(
                              text: driverProfileController
                                      .driverData.value?['colorcar'] ??
                                  '',
                              sectionName: 'Color Car',
                              onPressed: () =>
                                  driverProfileController.editField(
                                      context,
                                      'colorcar',
                                      driverProfileController
                                              .driverData.value?['colorcar'] ??
                                          ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
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
