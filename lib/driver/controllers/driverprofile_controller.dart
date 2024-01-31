// ProfileController
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/driver/models/driver_model.dart';
import 'package:catchpool/driver/pages/driverprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/notification_service.dart';

class DriverProfileController extends GetxController {
  Rx<DriverModel> driverModel = DriverModel.empty().obs;
  Rx<DocumentSnapshot?> driverData = Rx<DocumentSnapshot?>(null);
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> fetchDriverData(String userId) async {
    try {
      final driverDoc = await FirebaseFirestore.instance
          .collection("Drivers")
          .doc(userId)
          .get();

      if (driverDoc.exists) {
        final driverData = DriverModel.fromSnapshot(driverDoc);
        driverModel.value = driverData;
        this.driverData.value = driverDoc;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> editField(
      BuildContext context, String fieldName, String currentValue) async {
    TextEditingController textFieldController =
        TextEditingController(text: currentValue);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: 'Enter new $fieldName'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newValue = textFieldController.text.trim();

                if (newValue.isNotEmpty) {
                  try {
                    // Update the field in Firestore
                    await FirebaseFirestore.instance
                        .collection('Drivers')
                        .doc(currentUser.uid)
                        .update({fieldName: newValue});

                    // Update the local user model
                    switch (fieldName) {
                      case 'username':
                        driverModel.update((val) {
                          val!.username = newValue;
                        });
                        break;
                      case 'phone':
                        driverModel.update((val) {
                          val!.phone = newValue;
                        });
                        break;
                      case 'studentNo':
                        driverModel.update((val) {
                          val!.studentNo = newValue;
                        });
                        break;
                      case 'gender':
                        driverModel.update((val) {
                          val!.gender = newValue;
                        });
                        break;
                      case 'userType':
                        driverModel.update((val) {
                          val!.userType = newValue;
                        });
                        break;
                      case 'email':
                        driverModel.update((val) {
                          val!.email = newValue;
                        });
                        break;
                      case 'driverlicense':
                        driverModel.update((val) {
                          val!.driverlicense = newValue;
                        });
                        break;
                      case 'platecar':
                        driverModel.update((val) {
                          val!.platecar = newValue;
                        });
                        break;
                      case 'colorcar':
                        driverModel.update((val) {
                          val!.colorcar = newValue;
                        });
                        break;
                      case 'brandcar':
                        driverModel.update((val) {
                          val!.brandcar = newValue;
                        });
                        break;
                      case 'password':
                        driverModel.update((val) {
                          val!.password = newValue;
                        });
                        break;
                      // Add more cases for other fields if needed

                      default:
                        break;
                    }
                    await fetchDriverData(currentUser.uid);
                    updateVerificationStatus();
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error updating $fieldName: $e');
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showVerificationAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verification Required'),
          content: Text('Please verify your account first.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAll(() => DriverProfilePage());
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateVerificationStatus() async {
    final driverDoc =
        FirebaseFirestore.instance.collection("Drivers").doc(currentUser.uid);

    final driverData = await driverDoc.get();

    final driverLicense = driverData['driverlicense'] ?? '';
    final colorCar = driverData['colorcar'] ?? '';
    final brandCar = driverData['brandcar'] ?? '';
    final plateCar = driverData['platecar'] ?? '';

    if (driverLicense != "" &&
        colorCar != "" &&
        brandCar != "" &&
        plateCar != "") {
      // All required fields are not empty, update verification to "Verified"
      await driverDoc.update({'verification': 'Verified'});
      await NotificationService.showNotification(
        title: "Verified Account",
        body: "You're verified' - Happy 'CatchPool'ing!",
        summary: "CatchPool",
        notificationLayout: NotificationLayout.Default,
      );
      driverModel.update((val) {
        val!.verification = 'Verified';
      });
    }
  }
}

// ProfilePage
// ... (No changes here)
