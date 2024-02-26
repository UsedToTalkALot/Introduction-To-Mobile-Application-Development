import 'package:flutter/material.dart';
import 'package:walletwatch/components/btn.dart';
import 'package:firebase_database/firebase_database.dart';

class ReviewPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  ReviewPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(135, 206, 250, 100),
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
                  AppBar(
                    leading: IconButton(
                      icon: Image.asset(
                        "lib/image/back.png",
                        height: 24,
                        width: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    "Leave a Review !",
                    style: TextStyle(
                      color: Color.fromRGBO(223, 246, 255, 100),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "lib/image/review.png",
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Your message here",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyBtn(
                    text: 'Submit',
                    onTap: () {
                      saveReviewData(context);
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

  void saveReviewData(BuildContext context) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    String name = nameController.text;
    String message = messageController.text;

    Map<String, dynamic> reviewData = {
      'name': name,
      'message': message,
    };

    databaseReference.child('reviews').push().set(reviewData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thank you for your review!"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the landing page
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
