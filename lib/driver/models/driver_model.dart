import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  // attribute
  String id;
  String username;
  String fullname;
  String phone;
  String studentNo;
  String email;
  String password;
  String userType;
  String gender;
  String driverlicense;
  String platecar;
  String colorcar;
  String brandcar;
  String verification;

  // constructor
  DriverModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.phone,
    required this.studentNo,
    required this.email,
    required this.password,
    required this.userType,
    required this.gender,
    required this.driverlicense,
    required this.platecar,
    required this.colorcar,
    required this.brandcar,
    required this.verification,
  });

  // Static function to create an empty user model
  static DriverModel empty() =>
      DriverModel(
          id: '',
          username: '',
          fullname: '',
          phone: '',
          studentNo: '',
          email: '',
          password: '',
          userType: '',
          driverlicense: '',
          platecar: '',
          colorcar: '',
          brandcar: '',
          verification: '',
          gender: '');

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullname': fullname,
      'phone': phone,
      'studentNo': studentNo,
      'email': email,
      'password': password,
      'userType': userType,
      'driverlicense': driverlicense,
      'platecar': platecar,
      'colorcar': colorcar,
      'brandcar': brandcar,
      'verification': verification,
      'gender': gender,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'],
      username: map['username'] ?? '',
      fullname: map['fullname'] ?? '',
      phone: map['phone'] ?? '',
      studentNo: map['studentNo'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? '',
      gender: map['gender'] ?? '',
      driverlicense: map['driverlicense'] ?? '',
      platecar: map['platecar'] ?? '',
      colorcar: map['colorcar'] ?? '',
      brandcar: map['brandcar'] ?? '',
      verification: map['verification'] ?? '',
    );

}
  // Factory method to create a UserModel from a Firebase document snapshot
  factory DriverModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return DriverModel(
        id: document.id,
        username: data['username'] ?? '',
        fullname: data['fullname'] ?? '',
        phone: data['phone'] ?? '',
        studentNo: data['studentNo'] ?? '',
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        userType: data['userType'] ?? '',
        gender: data['gender'] ?? '',
        driverlicense: data['driverlicense'] ?? '',
        platecar: data['platecar'] ?? '',
        colorcar: data['colorcar'] ?? '',
        brandcar: data['brandcar'] ?? '',
        verification: data['verification'] ?? '',
      );
    }
    return DriverModel.empty();
  }
}
