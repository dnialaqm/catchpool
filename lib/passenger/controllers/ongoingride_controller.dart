import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/driver/models/driver_model.dart';
import 'package:catchpool/passenger/models/ride_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OngoingRideController extends GetxController {
  final Rx<RideModel?> ride = Rx<RideModel?>(null);
  final Rx<DriverModel?> driver = Rx<DriverModel?>(null);

  Future<void> fetchOngoingRideDetails(String rideId) async {
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
      print('Error fetching ongoing ride details: $error');
    }
  }
  Future<void> fetchOngoingRideDetailsForCurrentUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return; // Handle the case where the user is not authenticated
      }

      final userId = currentUser.uid;
      final ridesCollection = FirebaseFirestore.instance.collection('Rides');

      // Search for ongoing rides in each passengerId field separately
      final List<QuerySnapshot> queryResults = await Future.wait([
        ridesCollection
            .where('passengerId1', isEqualTo: userId)
            .where('status', isNotEqualTo: 'Complete')
            .get(),
        ridesCollection
            .where('passengerId2', isEqualTo: userId)
            .where('status', isNotEqualTo: 'Complete')
            .get(),
        ridesCollection
            .where('passengerId3', isEqualTo: userId)
            .where('status', isNotEqualTo: 'Complete')
            .get(),
        ridesCollection
            .where('passengerId4', isEqualTo: userId)
            .where('status', isNotEqualTo: 'Complete')
            .get(),
      ]);

      // Iterate through query results to find the first ongoing ride
      RideModel? ongoingRide;
      for (final queryResult in queryResults) {
        if (queryResult.docs.isNotEmpty) {
          ongoingRide = RideModel.fromMap(
            queryResult.docs.first.data() as Map<String, dynamic>,
          );
          break; // Found an ongoing ride, break the loop
        }
      }

      ride.value = ongoingRide; // Set the ongoing ride in ride.value

    } catch (error) {
      print('Error fetching ongoing ride details: $error');
    }
  }




  double calculateTotalPrice(String price, String pax) {
    final int fare = int.tryParse(price) ?? 0;
    final int person = int.tryParse(pax) ?? 0;

    if (fare > 0 && person > 0) {
      return fare.toDouble() / person.toDouble();
    }
    return 0.0;
  }


  Future<void> checkAndSendRideStartedNotification() async {
    // Check the ride status here and if it's "Ongoing," send the notification
    // You can fetch the ride status from your data source or controller
    String rideStatus = ride.value?.status ?? "";

    if (rideStatus == "Ongoing") {
      // Send the ride started notification here
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'basic_channel',
          title: "Ride Started",
          body: "Your Ride Started - Hang on!",
          summary: "Julbal",
        ),
      );
    }
  }


}