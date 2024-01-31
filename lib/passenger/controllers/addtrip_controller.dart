import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/passenger/models/ride_model.dart';
import 'package:catchpool/passenger/pages/ongoingride.dart';
import 'package:catchpool/passenger/pages/ride.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/authentication/login.dart';
import 'package:get/get.dart';

import '../../api/notification_service.dart';
import '../pages/navigation.dart';
import '../pages/ongoingride.dart';
import '../pages/ongoingride.dart';

class AddRideController extends GetxController {
  final pickupController = TextEditingController();
  final usernameController = TextEditingController();
  final dropoffController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

  final paxController = TextEditingController();

  String? currentRideId; // Add this variable

  final user = FirebaseAuth.instance.currentUser;
  String? username;

  RxList<RideModel> availableRides = <RideModel>[].obs;

  @override
  void onInit({String? rideId}) {
    fetchAvailableRides();
    if (rideId != null) {
      fetchRideDetails(rideId);
    }
    fetchUserData();
    super.onInit();
  }

  Future<String?> fetchCurrentUserGender() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return null; // Handle the case where the user is not authenticated
      }

      final currentUserId = currentUser.uid;

      // Fetch the gender of the current user
      final currentUserDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .get();

      if (!currentUserDoc.exists) {
        return null; // Handle the case where user data is not found
      }

      final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
      return currentUserData['gender'];
    } catch (e) {
      print("Error fetching current user's gender: $e");
      return null;
    }
  }
  Future<String?> fetchUserGender(String userId) async {
    try {
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
  void fetchAvailableRides() async {
    try {
      final currentUserGender = await fetchCurrentUserGender();
      if (currentUserGender == null) {
        return; // Handle the case where current user data is not available
      }

      final querySnapshot =
      await FirebaseFirestore.instance.collection("Rides").get();

      if (querySnapshot.docs.isNotEmpty) {
        // Clear the existing rides
        availableRides.clear();

        // Convert query snapshot to List of RideModel
        final rides = querySnapshot.docs
            .map((doc) => RideModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        // Filter out rides with status 'Complete' and where passengerId1 has the same gender as the current user
        final availableRidesList = <RideModel>[];

        for (final ride in rides) {
          final passengerId1Gender = await fetchUserGender(ride.userId);

          if (ride.status != 'Complete' &&
              ride.status != 'Ongoing' &&
              passengerId1Gender == currentUserGender) {
            availableRidesList.add(ride);
          }
        }

        // Add filtered rides to the availableRides list
        availableRides.addAll(availableRidesList);

        // Notify listeners
        ever(availableRides, (_) {
          // This will be called whenever availableRides changes
        });
        availableRides.refresh(); // Notify listeners
      } else {
        print("No available rides found.");
      }
    } catch (e) {
      print("Error fetching available rides: $e");
    }
  }

  void addRide() async {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user data to get the user's ID
        final userDoc = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userId = userData['id'];

          // Create a new ride, associating it with the user's ID
          final newRide = RideModel(
            id: null, // Firestore will auto-generate an ID
            userId: user.uid, // Assign the user's ID to the userId property
            username: usernameController.text.trim(),
            pickup: pickupController.text.trim(),
            dropoff: dropoffController.text.trim(),
            price: priceController.text.trim(),

            passengerId1: user.uid,
            passengerId2: "",
            passengerId3: "",
            passengerId4: "",
            driverId: "",
            status: "Pending Driver",
            pax: "1",
            date: dateController.text.trim(),
            time: timeController.text.trim(),
            bookingDate: DateTime.now(),
          );

          // Use add() without specifying a document ID to get an auto-generated ID
          final newRideRef = await FirebaseFirestore.instance
              .collection("Rides")
              .add(newRide.toJson());

          final newRideId = newRideRef.id;
          await NotificationService.showNotification(
            title: "Created New Ride",
            body: "You've created a new ride' - Happy 'CatchPool'ing!",
            summary: "CatchPool",
            notificationLayout: NotificationLayout.Default,
          );
          // Update the ride document with the generated ID
          await newRideRef.update({'id': newRideId});

          // Wait for Firestore to update, then fetch the rides
          await Future.delayed(const Duration(seconds: 2));
          fetchAvailableRides(); // This will update the local list

          Get.offAll(() => Ride());
        } else {
          print("User document not found for ID: ${user.uid}");
        }
      } else {
        // Handle the case where the user is not authenticated
        // You can redirect the user to the login page or display an error message.
        Get.offAll(() => Login());
      }
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close the dialog
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kPrimaryLightColor,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: backgroundColor),
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          username = userData['username'];
          update(); // Use update to notify GetX that the state has changed
        }
      } else {
        // Handle the case where user is null
        print("User is null");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void fetchRideDetails(String rideId) {
    currentRideId = rideId; // Store the current rideId

    // Modify this code to fetch and update the ride details as needed
    FirebaseFirestore.instance
        .collection('Rides')
        .doc(rideId)
        .get()
        .then((rideDoc) {
      // Rest of the code remains the same
    }).catchError((error) {
      print('Error fetching ride details: $error');
    });
  }

  Future<void> joinRide(BuildContext context, rideId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle the case where the user is not authenticated
        return;
      }
      final isUserInRide = await isUserInAnyRide(currentUser.uid);
      if (isUserInRide) {
        // Display an alert box because the user is already in a ride
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Ongoing Ride'),
              content: Text('You have an ongoing ride.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.offAll(() => OngoingRide());
// Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Exit the function
      }
      final rideRef =
          FirebaseFirestore.instance.collection('Rides').doc(rideId);
      final rideSnapshot = await rideRef.get();

      if (!rideSnapshot.exists) {
        // Handle the case where the ride document does not exist
        return;
      }

      final rideData =
          RideModel.fromMap(rideSnapshot.data() as Map<String, dynamic>);
      print('Ride Data Before Update: ${rideData.toJson()}');

      // Check for the first available passenger slot and update accordingly
      int filledSlots = 0;

      for (int i = 1; i <= 4; i++) {
        final passengerIdKey = 'passengerId$i';
        if (rideData[passengerIdKey] == currentUser.uid) {
          // Display an alert box because the user is already in a passenger slot
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Ongoing Ride'),
                content: Text('You have an ongoing ride.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return; // Exit the function
        }
        if (rideData[passengerIdKey] == "") {
          filledSlots = i;
          break;
        }
      }

      // Update the passenger's ID
      final passengerIdKey = 'passengerId$filledSlots';
      final existingStatus = rideData['status']; // Assuming you have access to the existing status

      final updatedStatus = existingStatus == 'Driver' ? 'Driver' : (filledSlots == 4 ? 'Pending Driver' : 'Pending Driver');

      // Update pax based on the number of filled passenger slots
      final updatedPax = filledSlots.toString();

      try {
        await rideRef.update({
          passengerIdKey: currentUser.uid,
          'status': updatedStatus,
          'pax': updatedPax,
        });

        // Fetch the updated data
        final updatedSnapshot = await rideRef.get();
        final updatedRideData =
            RideModel.fromMap(updatedSnapshot.data() as Map<String, dynamic>);
        print('Ride Data After Update: $updatedRideData');
        await NotificationService.showNotification(
          title: "Joined New Ride",
          body: "You've joined a new ride' - Happy 'CatchPool'ing!",
          summary: "CatchPool",
          notificationLayout: NotificationLayout.Default,
        );
        Get.offAll(() => OngoingRide(), arguments: rideId);
      } catch (e) {
        print('Error updating Firestore document: $e');
        // You can handle the error here or add more specific error handling
      }
    } catch (e) {
      print('Error updating Firestore document: $e');
      // You can handle the error here or add more specific error handling
    }
  }

  Future<bool> isUserInAnyRide(String userId) async {
    try {
      final ridesCollection = FirebaseFirestore.instance.collection('Rides');
      final ridesQuery =
          await ridesCollection.where('passengerId1', isEqualTo: userId).get();

      final ridesQuery2 =
          await ridesCollection.where('passengerId2', isEqualTo: userId).get();

      final ridesQuery3 =
          await ridesCollection.where('passengerId3', isEqualTo: userId).get();

      final ridesQuery4 =
          await ridesCollection.where('passengerId4', isEqualTo: userId).get();

      return ridesQuery.docs.isNotEmpty ||
          ridesQuery2.docs.isNotEmpty ||
          ridesQuery3.docs.isNotEmpty ||
          ridesQuery4.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user is in any ride: $e');
      return false;
    }
  }
}
