import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  Future<List<Map<String, dynamic>>> fetchDataFromFirebase() async {
    // Use try-catch block to handle potential errors
    try {
      // Wait for the database event
      DatabaseEvent event = await _database.child('transactions').once();

      // Extract DataSnapshot from the event
      DataSnapshot dataSnapshot = event.snapshot;

      // Check if the snapshot has data
      if (dataSnapshot.value != null) {
        // Convert snapshot data to list of maps
        List<Map<String, dynamic>> transactions = [];
        (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          transactions.add(Map<String, dynamic>.from(value));
        });

        return transactions;
      } else {
        // Return an empty list if no data is available
        return [];
      }
    } catch (error) {
      // Handle any potential errors
      print('Error fetching data from Firebase: $error');
      throw error; // Re-throw the error for higher level handling
    }
  }

  Future<List<Map<String, dynamic>>> fetchReviewDataFromFirebase() async {
    try {
      DatabaseEvent event = await _database.child('reviews').once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        List<Map<String, dynamic>> reviews = [];
        (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          if (value != null && value is Map<dynamic, dynamic>) {
            // Perform explicit null checks and type checks
            String name = (value['name'] ?? '').toString();
            String message = (value['message'] ?? '').toString();

            // Check if either 'name' or 'message' is not empty before adding to the list
            if (name.isNotEmpty || message.isNotEmpty) {
              // Add the review to the list
              reviews.add({
                'name': name,
                'message': message,
                // Add other properties if available in your data
              });
            }
          }
        });

        return reviews;
      } else {
        return [];
      }
    } catch (error) {
      print('Error fetching review data from Firebase: $error');
      throw error;
    }

  }








}
