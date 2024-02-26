import 'package:flutter/material.dart';
import 'package:walletwatch/main.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        //margin: EdgeInsets.only(left: 30),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: MyApp.textColor),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyApp.textColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyApp.btnColor)),
              hintText: hintText,
              hintStyle: TextStyle(color: MyApp.textColor)),
        ),
      ),
    );
  }
}
