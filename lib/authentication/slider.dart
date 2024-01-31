import '../constants.dart';
import 'intro1.dart';
import 'intro2.dart';
import 'intro3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MaterialApp(
    home: SplashPage(),
  ));
}

class SplashPage extends StatelessWidget {
  final _controller = PageController();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 750,
            child: PageView(
              controller: _controller,
              children: [
                Intro1(),
                Intro2(),
                Intro3(),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: kPrimaryLightColor,
              dotColor: kPrimaryLightColor.withOpacity(0.10),
              dotHeight: 20,
              dotWidth: 20,
            ),
          ),
        ],
      ),
    );
  }
}
