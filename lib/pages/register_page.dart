import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walletwatch/components/btn.dart';
import 'package:walletwatch/components/textfield.dart';
import 'package:walletwatch/main.dart';
import 'package:walletwatch/pages/home_page.dart';
import 'package:walletwatch/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up user
  void signUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        showErrorMessage("Password doesn't Match");
      }

      // Successfully signed in
      Navigator.pop(context);
      Navigator.pushReplacement(
        // Replace current screen with the next one
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(), // Replace NextScreen with your desired screen
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
                  Text(
                    "Create an account",
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


                  //email textfield
                  SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),

                  //password textfield
                  SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),

                  //confirm password textfield
                  SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),

                  //forgot password
                  SizedBox(height: 20),

                  SizedBox(height: 20),
                  MyBtn(
                    text: 'Sign in',
                    onTap: signUp,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have and account?",
                        style: TextStyle(color: MyApp.textColor, fontSize: 15),
                      ),
                      GestureDetector(
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
                        child: Text(
                          " Login Now",
                          style: TextStyle(color: MyApp.btnColor, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
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
                  SizedBox(
                    height: 20,
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
