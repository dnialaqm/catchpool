import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/driver/models/driver_model.dart';
import 'package:catchpool/passenger/models/ride_model.dart';
import 'package:catchpool/passenger/pages/ongoingride.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/notification_service.dart';

import '../../authentication/login.dart';
import '../../constants.dart';
import '../../passenger/pages/completed.dart';
import '../pages/driverongoing.dart';
import '../pages/driverride.dart';

class DriverRideController extends GetxController {
  final pickupController = TextEditingController();
  final usernameController = TextEditingController();
  final dropoffController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

  final paxController = TextEditingController();
  Rx<DriverModel> driverModel = DriverModel.empty().obs;
  Rx<DocumentSnapshot?> driverData = Rx<DocumentSnapshot?>(null);
  final currentUser = FirebaseAuth.instance.currentUser;
  String? currentRideId; // Add this variable
  String? username;
  Rx<RideModel?> ride = Rx<RideModel?>(null);

  RxList<RideModel> pendingDriverRides =
      <RideModel>[].obs; // New list for pending driver rides

  @override
  void onInit({String? rideId}) {
    fetchPendingDriverRides(); // Fetch pending driver rides
    if (rideId != null) {
      fetchRideDetails(rideId);
    }
    super.onInit();
  }

  Future<String?> fetchCurrentDriverGender() async {
    try {
      final currentDriver = FirebaseAuth.instance.currentUser;
      if (currentDriver == null) {
        return null; // Handle the case where the user is not authenticated
      }

      final currentDriverId = currentDriver.uid;

      // Fetch the gender of the current user
      final currentDriverDoc = await FirebaseFirestore.instance
          .collection("Drivers")
          .doc(currentDriverId)
          .get();

      if (!currentDriverDoc.exists) {
        return null; // Handle the case where user data is not found
      }

      final currentDriverData = currentDriverDoc.data() as Map<String, dynamic>;
      return currentDriverData['gender'];
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
        return userData['gender'] ??
            ""; // Replace 'gender' with the actual field name for the user's gender in your Firestore document
      } else {
        print('User document not found for ID: $userId');
      }
    } catch (error) {
      print('Error fetching user\'s gender: $error');
    }
    return null;
  }

  void fetchPendingDriverRides() async {
    try {
      final currentDriverGender = await fetchCurrentDriverGender();
      if (currentDriverGender == null) {
        return; // Handle the case where current user data is not available
      }

      final querySnapshot =
          await FirebaseFirestore.instance.collection("Rides").get();

      if (querySnapshot.docs.isNotEmpty) {
        // Clear the existing rides
        pendingDriverRides.clear();

        // Convert query snapshot to List of RideModel
        final rides = querySnapshot.docs
            .map((doc) => RideModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        // Filter out rides with status 'Complete' and where passengerId1 has the same gender as the current user
        final pendingDriverRidesList = <RideModel>[];

        for (final ride in rides) {
          final passengerId1Gender = await fetchUserGender(ride.userId);

          if (ride.status == 'Pending Driver' &&
              passengerId1Gender == currentDriverGender) {
            pendingDriverRides.add(ride);
          }
        }

        // Add filtered rides to the availableRides list
        pendingDriverRides.addAll(pendingDriverRidesList);

        // Notify listeners
        ever(pendingDriverRides, (_) {
          // This will be called whenever availableRides changes
        });
        pendingDriverRides.refresh(); // Notify listeners
      } else {
        print("No available rides found.");
      }
    } catch (e) {
      print("Error fetching available rides: $e");
    }
  }

  void fetchRideDetails(String rideId) {
    currentRideId = rideId; // Store the current rideId

    // Modify this code to fetch and update the ride details as needed
    FirebaseFirestore.instance
        .collection('Rides')
        .doc(rideId)
        .snapshots()
        .listen((rideDoc) {
      if (rideDoc.exists) {
        final rideData =
            RideModel.fromMap(rideDoc.data() as Map<String, dynamic>);
        ride.value = rideData;
      } else {
        print('Ride document not found for ID: $rideId');
      }
    });
  }

  Future<void> giveRide(BuildContext context, rideId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle the case where the user is not authenticated
        return;
      }
      final isUserInRide = await isDriverInAnyRide(currentUser.uid);
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

      // Update driverId and status
      try {
        await NotificationService.showNotification(
          title: "Accepted Ride",
          body: "You've accepted a ride' - Happy Drive!",
          summary: "CatchPool",
          notificationLayout: NotificationLayout.Default,
        );
        await rideRef.update({
          'driverId': currentUser.uid,
          'status': 'Driver',
        });

        // Fetch the updated data
        final updatedSnapshot = await rideRef.get();
        final updatedRideData =
            RideModel.fromMap(updatedSnapshot.data() as Map<String, dynamic>);
        print('Ride Data After Update: $updatedRideData');

        Get.offAll(() => DriverOngoingRide(), arguments: rideId);
      } catch (e) {
        print('Error updating Firestore document: $e');
        // You can handle the error here or add more specific error handling
      }
    } catch (e) {
      print('Error updating Firestore document: $e');
      // You can handle the error here or add more specific error handling
    }
  }

  Future<bool> isDriverInAnyRide(String userId) async {
    try {
      final ridesCollection = FirebaseFirestore.instance.collection('Rides');
      final ridesQuery =
          await ridesCollection.where('driverId', isEqualTo: userId).get();

      return ridesQuery.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user is in any ride: $e');
      return false;
    }
  }

  Future<void> fetchDriverOngoingRideDetails(String rideId) async {
    try {
      final rideDoc = await FirebaseFirestore.instance
          .collection('Rides')
          .doc(rideId)
          .get();

      if (rideDoc.exists) {
        final rideData =
            RideModel.fromMap(rideDoc.data() as Map<String, dynamic>);
        ride.value = rideData;
      } else {
        print('Ride document not found for ID: $rideId');
      }
    } catch (error) {
      print('Error fetching driver\'s ongoing ride details: $error');
    }
  }

  Future<void> fetchDriverOngoingRideDetailsForCurrentUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return; // User is not authenticated, handle appropriately.
      }

      final userId = currentUser.uid;
      final ridesCollection = FirebaseFirestore.instance.collection('Rides');

      // Query the 'Rides' collection where 'driverId' matches the current user's ID
      // and the 'status' is not 'Complete'.
      final ridesQuery = await ridesCollection
          .where('driverId', isEqualTo: userId)
          .where('status', isNotEqualTo: 'Complete')
          .get();

      if (ridesQuery.docs.isNotEmpty) {
        // If there are any rides that meet the criteria, process the first one.
        final rideData = RideModel.fromMap(ridesQuery.docs.first.data());
        ride.value = rideData; // Assuming 'ride' is an Rx<RideModel> or similar.
      } else {
        // No ongoing rides found that meet the criteria.
        ride.value = null;
      }
    } catch (error) {
      print('Error fetching driver\'s ongoing ride details: $error');
    }
  }


  void driverAddRide() async {
    try {
      final driver = FirebaseAuth.instance.currentUser;
      if (driver != null) {
        // Fetch user data to get the user's ID
        final driverDoc = await FirebaseFirestore.instance
            .collection("Drivers")
            .doc(driver.uid)
            .get();

        if (driverDoc.exists) {
          final driverData = driverDoc.data() as Map<String, dynamic>;
          final driverId = driverData['id'];

          // Create a new ride, associating it with the user's ID
          final newRide = RideModel(
            id: null, // Firestore will auto-generate an ID
            userId: driver.uid, // Assign the user's ID to the userId property
            username: usernameController.text.trim(),
            pickup: pickupController.text.trim(),
            dropoff: dropoffController.text.trim(),
            price: priceController.text.trim(),

            passengerId1: "",
            passengerId2: "",
            passengerId3: "",
            passengerId4: "",
            driverId: driver.uid,
            status: "Driver",
            pax: "0",
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
          fetchPendingDriverRides(); // This will update the local list

          Get.offAll(() => DriverRide());
        } else {
          print("User document not found for ID: ${driver.uid}");
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

  void finishRide(RideModel ride, BuildContext context) async {
    try {
      final rideRef =
          FirebaseFirestore.instance.collection('Rides').doc(ride.id);
      await NotificationService.showNotification(
        title: "Ride Completed",
        body: "You've reached your destination' - Goodbye!",
        summary: "CatchPool",
        notificationLayout: NotificationLayout.Default,
      );
      // Update the ride status to "Complete"
      await rideRef.update({'status': 'Complete'});
      Get.offAll(() => DriverOngoingRide());

      // Show the CompleteRidePopup as a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: CompleteRidePopup(
              onClose: () {
                Navigator.of(context).pop(); // Close the popup
              },
              ride: ride, // Pass the ride parameter
            ),
          );
        },
      );
    } catch (e) {
      print('Error updating ride status: $e');
      // Handle the error as needed
    }
  }

  void showCompletedRideDialog() {
    // Show a dialog to inform the driver that the ride has been completed
    // Example: showDialog(...);
  }

  void startRide(RideModel ride) async {
    try {
      final rideRef = FirebaseFirestore.instance.collection('Rides').doc(ride.id);

      await NotificationService.showNotification(
        title: "Ride Started",
        body: "Your Ride Started - Hold on tight!",
        summary: "CatchPool",
        notificationLayout: NotificationLayout.Default,
      );

      await rideRef.update({'status': 'Ongoing'});
      Get.offAll(() => DriverOngoingRide());

      // Notify the user that the ride has started (you can show a dialog or a snackbar)
      // Example: showRideStartedDialog();

      // You can also perform any other necessary actions here.
    } catch (e) {
      print('Error updating ride status: $e');
      // Handle the error as needed
    }
  }


  void showRideStartedDialog() {
    // Show a dialog to inform the driver that the ride has started
    // Example: showDialog(...);
  }
}
