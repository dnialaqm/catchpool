import 'package:catchpool/passenger/models/ride_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final RxList<RideModel> completedRides = RxList<RideModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCompletedRidesForCurrentUser();
  }

  Future<void> fetchCompletedRidesForCurrentUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return; // Handle the case where the user is not authenticated
      }

      final userId = currentUser.uid;

      final ridesCollection = FirebaseFirestore.instance.collection('Rides');

      // Create a list to store the results from different queries
      final List<RideModel> rides = [];

      // Query 1: where 'userId' is equal to the current user's ID
      final query1 = await ridesCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query1.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      // Query 2: where any 'passengerIdX' is equal to the current user's ID
      final query2 = await ridesCollection
          .where('passengerId1', isEqualTo: userId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query2.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      final query3 = await ridesCollection
          .where('passengerId2', isEqualTo: userId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query3.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      final query4 = await ridesCollection
          .where('passengerId3', isEqualTo: userId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query4.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      final query5 = await ridesCollection
          .where('passengerId4', isEqualTo: userId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query5.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      // Remove duplicates if any (based on ride ID)
      final uniqueRides = <RideModel>[];
      for (final ride in rides) {
        if (!uniqueRides.any((r) => r.id == ride.id)) {
          uniqueRides.add(ride);
        }
      }

      completedRides.assignAll(uniqueRides);
    } catch (error) {
      print('Error fetching completed rides: $error');
    }
  }
}