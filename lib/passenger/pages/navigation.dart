
import 'package:catchpool/constants.dart';
import 'package:catchpool/passenger/pages/ongoingride.dart';
import 'package:catchpool/passenger/pages/profile.dart';
import 'package:catchpool/passenger/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:catchpool/passenger/pages/history.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Home(),
      OngoingRide(),
      History(),
      ProfilePage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: kPrimaryLightColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: GNav(
            backgroundColor: kPrimaryLightColor,
            color: Colors.white,
            activeColor: kPrimaryColor,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 3,
            onTabChange: (index) {
              _navigateBottomBar(index); // Call the navigation method
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.directions_car,
                text: 'Ride',
              ),
              GButton(
                icon: Icons.history,
                text: 'History',
              ),
              GButton(
                icon: Icons.person,
                text: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
