import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
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

  // constructor
  UserModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.phone,
    required this.studentNo,
    required this.email,
    required this.password,
    required this.userType,
    required this.gender,
  });

  // Static function to create an empty user model
  static UserModel empty() => UserModel(
      id: '',
      username: '',
      fullname: '',
      phone: '',
      studentNo: '',
      email: '',
      password: '',
      userType: '',
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
      'gender': gender,
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        username: data['username'] ?? '',
        fullname: data['fullname'] ?? '',
        phone: data['phone'] ?? '',
        studentNo: data['studentNo'] ?? '',
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        userType: data['userType'] ?? '',
        gender: data['gender'] ?? '',
      );
    }
    return UserModel.empty();
  }
}
