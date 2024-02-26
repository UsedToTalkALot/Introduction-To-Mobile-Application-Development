import 'package:flutter/material.dart';
import 'package:walletwatch/services/firebase_service.dart';

class ViewReviewsPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
        backgroundColor: Colors.lightBlue[50],
        leading: IconButton(
          icon: Image.asset('lib/image/back.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent, // Background color
        ),
        child: FutureBuilder(
          future: _firebaseService.fetchReviewDataFromFirebase(),
          builder: (context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> reviews = snapshot.data!;

              reviews.sort((a, b) {
                String nameA = (a['name'] ?? '').toString();
                String nameB = (b['name'] ?? '').toString();
                return nameA.compareTo(nameB);
              });


              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> review = reviews[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[50], // Lighter shade of blue
                        borderRadius: BorderRadius.circular(
                            15.0), // Circular rectangle
                      ),
                      child: ListTile(
                        title: Text('Name: ${review['name'] ?? 'N/A'}'),
                        subtitle: Text(
                            'Message: ${review['message'] ?? 'N/A'}'),

                      ),

                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}