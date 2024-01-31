// ProfilePage
import 'package:catchpool/components/my_textbox.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/passenger/controllers/profile_controller.dart';
import 'package:catchpool/passenger/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.put(ProfileController());
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await profileController.fetchUserData(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(() => SettingsScreen()),
            icon: Icon(
              Icons.settings,
              color: backgroundColor, // Change this to your desired icon color
            ),
          )

        ],
        backgroundColor: kPrimaryLightColor,
        title: Text(
          'My Profile',
          style: TextStyle(fontFamily: 'Poppins', color: backgroundColor),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot?>(
        stream: profileController.userData.stream,
        builder: (context, snapshot) {
          // Check if data is available and not null
          if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot.data!.data()! as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 30),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: kPrimaryLightColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                FutureBuilder<String?>(
                  future: fetchUserGender(), // Replace with your function to fetch user's gender
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
                    profileController.userModel.value.fullname,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kPrimaryLightColor),
                  ),
                ),
                MyTextBox(
                  text: userData['fullname'],
                  sectionName: 'Fullname',
                  onPressed: () => profileController.editField(
                      context, 'fullname', userData['fullname']),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'Username',
                  onPressed: () => profileController.editField(
                      context, 'username', userData['username']),
                ),
                MyTextBox(
                  text: userData['phone'],
                  sectionName: 'Phone',
                  onPressed: () => profileController.editField(
                      context, 'phone', userData['phone']),
                ),
                MyTextBox(
                  text: userData['studentNo'],
                  sectionName: 'Student No',
                  onPressed: () => profileController.editField(
                      context, 'studentNo', userData['studentNo']),
                ),
                MyTextBox(
                  text: userData['gender'],
                  sectionName: 'Gender',
                  onPressed: () => profileController.editField(
                      context, 'gender', userData['gender']),
                ),
                MyTextBox(
                  text: userData['userType'],
                  sectionName: 'User Type',
                  onPressed: () => profileController.editField(
                      context, 'userType', userData['userType']),
                ),
                MyTextBox(
                  text: userData['email'],
                  sectionName: 'Email',
                  onPressed: () => profileController.editField(
                      context, 'email', userData['email']),
                ),
                MyTextBox(
                  text: userData['password'],
                  sectionName: 'Password',
                  onPressed: () => profileController.editField(
                      context, 'password', userData['password']),
                ),
                const SizedBox(height: 50),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<String?> fetchUserGender() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return null; // Handle the case where the user is not authenticated
    }

    final userId = currentUser.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['gender'] ?? ""; // Replace 'gender' with the actual field name for the user's gender in your Firestore document
    } else {
      print('User document not found for ID: $userId');
    }
  } catch (error) {
    print('Error fetching user\'s gender: $error');
  }
  return null;
}
