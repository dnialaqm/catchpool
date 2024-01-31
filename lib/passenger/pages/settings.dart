import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:catchpool/constants.dart';
import 'package:catchpool/passenger/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/notification_service.dart';
import '../../authentication/login.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // You can use shared preferences or user settings to get the actual value
  bool isNotificationsEnabled = true; // This should be fetched from user preferences or settings
  var appInfo = AppInfo().obs; // Make sure 'AppInfo' is a class you have defined with appName and version.

  // Add any other state variables you need for the settings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // This should match your theme or user's preference
      appBar: AppBar(
        title: Text('Settings',
          style: TextStyle(fontFamily: 'Poppins', color: backgroundColor),
        ),
        backgroundColor: kPrimaryLightColor,
        centerTitle: true,

      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          ListTile(
            title: Text('My Profile'),
            leading: Icon(Icons.person),
            onTap: () {
              Get.to(() => const ProfilePage());
            },
          ),
          // SwitchListTile(
          //   title: Text('Dark Mode'),
          //   secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          //   value: isDarkMode,
          //   onChanged: (bool value) {
          //     setState(() {
          //       isDarkMode = value;
          //       // Implement the logic to enable/disable dark mode
          //     });
          //   },
          // ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Notifications'),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SwitchListTile(
                          value: isNotificationsEnabled,
                          title: Text(isNotificationsEnabled ? 'Enabled' : 'Disabled'),
                          onChanged: (bool value) {
                            setState(() {
                              isNotificationsEnabled = value;
                              // Save the new setting to user preferences or settings
                            });
                          },
                        );
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(), // Close the dialog
                      ),
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          // Save the setting and close the dialog
                          saveNotificationPreference(isNotificationsEnabled);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
,
          ListTile(
            title: Text('Support'),
            leading: Icon(Icons.help),
            onTap: () {
    showAboutDialog(
    context: context,
    applicationName: appInfo.value.appName,
    applicationVersion: 'Version: ${appInfo.value.version}',
    applicationLegalese: '©2024 Danial Aqeem', // You can put your copyright notice here
    applicationIcon: Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
    child: Image(
    image: const AssetImage('assets/images/logo.png'), // Replace with your asset image path
    height: MediaQuery.of(context).size.height * 0.10,
    ),
    ),
    children: <Widget>[
    // You can add more widgets here if you want to provide more information
    Padding(
    padding: const EdgeInsets.only(top: 15),
    child: Text('CatchPool is a ride-sharing app designed to make commuting simple, efficient, and eco-friendly.'),
    ),
    ],
    );
    },

          ),
          ListTile(
            title: Text('Deactivate Account'),
            leading: Icon(Icons.delete_forever),
            onTap: () {
              showDeleteAccountDialog(context); // Call the function directly here
            },
          ),

          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.logout),
            onTap:     () => signUserOut(),
          ),
        ],
      ),
    );
  }
}

// You would need to integrate this SettingsScreen into your navigation logic.
// Don't forget to add the proper routes and ensure you're handling the user's preferences for things like dark mode appropriately.
void signUserOut() async {
  await FirebaseAuth.instance.signOut();
  Get.to(() => const Login());
}

Future<void> saveNotificationPreference(bool isEnabled) async {
  // Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();
  // Save the notification preference.
  await prefs.setBool('notificationsEnabled', isEnabled);

  // If you are using Firebase Cloud Messaging (FCM), you might call `FirebaseMessaging.instance.subscribeToTopic('all')` to subscribe the user to a topic
  // and `FirebaseMessaging.instance.unsubscribeFromTopic('all')` to unsubscribe the user.
  // Here is a pseudo-code example:
  if (isEnabled) {
    // Subscribe the user to a topic for FCM, or enable your app's notifications
    print('User has enabled notifications.');
    // Example for FCM: await FirebaseMessaging.instance.subscribeToTopic('all');
  } else {
    // Unsubscribe the user from a topic for FCM, or disable your app's notifications
    print('User has disabled notifications.');
    // Example for FCM: await FirebaseMessaging.instance.unsubscribeFromTopic('all');
  }

  // After saving the preference, you could also update the UI or app state as needed.
}Future<void> showDeleteAccountDialog(BuildContext context) async {
  // Show confirmation dialog
  final bool confirmDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This cannot be undone.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false), // Dismiss and return false
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true), // Proceed with deletion and return true
          ),
        ],
      );
    },
  ) ?? false; // if dialog is dismissed, return false

  // If deletion is confirmed, proceed to delete the account
  if (confirmDelete) {
    bool success = await deleteAccount(context); // Capture the success of deletion
    if (success) {
      await NotificationService.showNotification(
        title: "Deleted Account",
        body: "You've deleted your account' - See you again :(",
        summary: "CatchPool",
        notificationLayout: NotificationLayout.Default,
      );      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Deleted'),
            content: const Text('You have successfully deleted your account.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  Get.offAll(() => const Login()); // Navigate to login screen
                },
              ),
            ],
          );
        },
      );
    }
  }
}

Future<bool> deleteAccount(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No user is signed in.');
    return false;
  }

  try {
    // Delete the user's data from Firestore
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userDocRef.delete();

    // Delete the user's auth record
    await user.delete();

    // Sign the user out
    await FirebaseAuth.instance.signOut();
    print('User signed out.');

    return true; // Return true on successful deletion
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      print('User needs to re-authenticate to delete their account.');
      // Prompt the user to re-authenticate here
    } else {
      print('An error occurred while deleting the account: ${e.message}');
    }
    return false; // Return false on failure
  } catch (e) {
    print('An error occurred while deleting the account: $e');
    return false; // Return false on failure
  }
}


class AppInfo {
  String appName = 'CatchPool'; // Your App Name
  String version = '1.0.0'; // Your App Version
}