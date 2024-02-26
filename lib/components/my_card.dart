import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double balance;
  final String type;
  final color;
  const MyCard({
    Key? key,
    required this.balance,
    required this.type,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              type,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Nrs. " + balance.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
