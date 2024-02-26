import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walletwatch/components/btn.dart';
import 'package:walletwatch/components/textfield.dart';
import 'package:walletwatch/main.dart';
import 'package:walletwatch/pages/home_page.dart';
import 'package:walletwatch/pages/landing_page.dart';
import 'package:walletwatch/pages/register_page.dart';
import 'package:walletwatch/pages/view_reviews_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign in user
  void signIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try signin
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Successfully signed in
      Navigator.pop(context);
      Navigator.pushReplacement(
        // Replace current screen with the next one
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewReviewsPage(), // Replace NextScreen with your desired screen
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // wrong email
      showErrorMessage(e.code);
    }
  }

  //show error message

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            message,
            style: const TextStyle(color: Colors.black),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make the scaffold background transparent
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000000), // Start color (#47B5FF)
              Color(0xFF06283D), // End color (#06283D)
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
                  AppBar(
                    leading: IconButton(
                      icon: Image.asset(
                        "lib/image/back.png",
                        height: 24,
                        width: 24,
                      ),
                      onPressed: () {
                        // Navigate back to the landing page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingPage(),
                          ),
                        );
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0, // Remove AppBar shadow
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You need to login first!",
                    style: TextStyle(
                      color: Color.fromRGBO(223, 246, 255, 100),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "lib/image/review.png",
                    height: 120,
                    width: 120,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Control, Track, Grow, With WalletWatch",
                    style: TextStyle(
                      color: Color.fromRGBO(223, 246, 255, 100),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password ?",
                          style: TextStyle(color: MyApp.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MyBtn(
                    text: 'Log in',
                    onTap: signIn,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Haven't Signed Up?",
                        style: TextStyle(color: MyApp.textColor, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                        child: Text(
                          " Register Now",
                          style: TextStyle(color: MyApp.btnColor, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.3,
                            color: MyApp.textColor,
                          ),
                        ),

                        Expanded(
                          child: Divider(
                            thickness: 0.3,
                            color: MyApp.textColor,
                          ),
                        )
                      ],
                    ),
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
