import 'package:catchpool/driver/models/driver_model.dart';
import 'package:catchpool/passenger/models/ride_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DriverHistoryController extends GetxController {
  final RxList<RideModel> completedDriverRides = RxList<RideModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCompletedRidesForCurrentDriver();
  }

  Future<void> fetchCompletedRidesForCurrentDriver() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return; // Handle the case where the user is not authenticated
      }

      final driverId = currentUser.uid;

      final ridesCollection = FirebaseFirestore.instance.collection('Rides');

      final List<RideModel> rides = [];

      final query1 = await ridesCollection
          .where('userId', isEqualTo: driverId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query1.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      final query2 = await ridesCollection
          .where('driverId', isEqualTo: driverId)
          .where('status', isEqualTo: 'Complete')
          .get();
      rides.addAll(query2.docs
          .map((document) =>
          RideModel.fromMap(document.data() as Map<String, dynamic>))
          .toList());

      final uniqueRides = <RideModel>[];
      for (final ride in rides) {
        if (!uniqueRides.any((r) => r.id == ride.id)) {
          uniqueRides.add(ride);
        }
      }

      completedDriverRides.assignAll(uniqueRides);
    } catch (error) {
      print('Error fetching completed rides for driver: $error');
    }
  }
}
