import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:catchpool/components/my_button.dart';
import 'package:catchpool/components/my_textfield.dart';
import 'package:catchpool/components/square_tile.dart';
import 'register_controller.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

enum Gender { male, female }

class _RegisterState extends State<Register> {
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Icon(
                      Icons.app_registration_outlined,
                      color: kPrimaryLightColor,
                      size: 100,
                    ),
                    const SizedBox(height: 25),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Text(
                          'Register',
                          style: TextStyle(
                            color: kPrimaryLightColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Text(
                          'Start your journey with CatchPool',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Gender>(
                              decoration: const InputDecoration(
                                labelText: 'Select Gender',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: textColor, // Border color
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                labelStyle: TextStyle(
                                  color: textColor, // Label text color
                                ),
                                hintStyle: TextStyle(
                                  color: textColor, // Hint text color
                                ),
                              ),
                              style: const TextStyle(
                                  color: textColor,
                                  fontFamily:
                                      'Poppins' // Dropdown item text color
                                  ),
                              value: controller.selectedGender,
                              onChanged: (Gender? genderValue) {
                                setState(() {
                                  controller.selectedGender = genderValue;
                                });
                              },
                              items: const [
                                DropdownMenuItem<Gender>(
                                  value: Gender.male,
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem<Gender>(
                                  value: Gender.female,
                                  child: Text('Female'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select User Type',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: textColor, // Border color
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                labelStyle: TextStyle(
                                  color: textColor, // Label text color
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white70, // Hint text color
                                ),
                              ),
                              style: const TextStyle(
                                  color: textColor,
                                  fontFamily:
                                      'Poppins' // Dropdown item text color
                                  ),
                              value: controller.selectedUserType,
                              onChanged: (String? userValue) {
                                setState(() {
                                  controller.selectedUserType = userValue;
                                });
                              },
                              items: ['Passenger', 'Driver']
                                  .map<DropdownMenuItem<String>>(
                                    (String userType) =>
                                        DropdownMenuItem<String>(
                                      value: userType,
                                      child: Text(userType),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    MyTextField(
                      controller: controller.fullnameController,
                      hintText: 'Full Name',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),
                    // EMAIL TEXTBOX
                    MyTextField(
                      controller: controller.usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // PHONE TEXTBOX
                    MyTextField(
                      controller: controller.phoneController,
                      hintText: 'Phone',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // STUDENT NO TEXTBOX
                    MyTextField(
                      controller: controller.studentNoController,
                      hintText: 'Student No',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // EMAIL TEXTBOX
                    MyTextField(
                      controller: controller.emailController,
                      hintText: 'Email Address',
                      obscureText: false,
                    ),

                    const SizedBox(height: 25),

                    // PASSWORD TEXTBOX
                    MyTextField(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 25),

                    // SIGN UP BUTTON
                    MyButton(
                      onTap: () => controller.saveUserData(),
                      buttonName: 'Register',
                    ),

                    const SizedBox(height: 30),

                    // LOGIN LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a member?',
                          style: TextStyle(color: textColor),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const Login());
                          },
                          child: const Text(
                            'Login Now!',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
