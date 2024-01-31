// ProfileController
import 'package:catchpool/passenger/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rx<UserModel> userModel = UserModel.empty().obs;
  Rx<DocumentSnapshot?> userData = Rx<DocumentSnapshot?>(null);
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> fetchUserData(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = UserModel.fromSnapshot(userDoc);
        userModel.value = userData;
        this.userData.value = userDoc;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

// Inside ProfileController class
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
                        .collection('Users')
                        .doc(currentUser.uid)
                        .update({fieldName: newValue});

                    // Update the local user model
                    switch (fieldName) {
                      case 'username':
                        userModel.update((val) {
                          val!.username = newValue;
                        });
                        break;
                      case 'phone':
                        userModel.update((val) {
                          val!.phone = newValue;
                        });
                        break;
                      case 'studentNo':
                        userModel.update((val) {
                          val!.studentNo = newValue;
                        });
                        break;
                      case 'gender':
                        userModel.update((val) {
                          val!.gender = newValue;
                        });
                        break;
                      case 'userType':
                        userModel.update((val) {
                          val!.userType = newValue;
                        });
                        break;
                      case 'email':
                        userModel.update((val) {
                          val!.email = newValue;
                        });
                        break;
                      case 'password':
                        userModel.update((val) {
                          val!.password = newValue;
                        });
                        break;
                      // Add more cases for other fields if needed

                      default:
                        break;
                    }
                    await fetchUserData(currentUser.uid);

                    // Close the dialog
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
}

// ProfilePage
// ... (No changes here)
