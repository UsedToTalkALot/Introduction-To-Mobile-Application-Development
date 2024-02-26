import 'package:flutter/material.dart';
import 'package:walletwatch/components/btn.dart';
import 'package:walletwatch/main.dart';
import 'package:walletwatch/pages/home_page.dart';
import 'package:walletwatch/pages/login_page.dart';
import 'package:walletwatch/pages/review_page.dart';




class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000000),
              Color(0xFF06283D),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome to Red Panda Inc!",
                    style: TextStyle(
                      color: Color.fromRGBO(223, 246, 255, 100),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    "lib/image/review.png",
                    height: 120,
                    width: 120,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  MyBtn(
                    text: 'Give Review',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(

                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  MyBtn(
                    text: 'View Review',
                    onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => LoginPage(
                  onTap: () {},
                  ),
                  ),
                  );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
