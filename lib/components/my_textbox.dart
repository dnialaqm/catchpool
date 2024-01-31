import 'package:catchpool/constants.dart';
import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final Function()? onPressed;

  const MyTextBox({
    Key? key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kPrimaryLightColor, // Set your desired border color here
          width: 1.0, // Set your desired border width here
        ),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color:  Color(0xFFC4AE78),
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.settings, color: kPrimaryLightColor ),
              ),
            ],
          ),
          Text(
            text,
            style: TextStyle(
              color: kPrimaryLightColor,
            ),
          ),
        ],
      ),
    );
  }
}
