import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walletwatch/components/list.dart';
import 'package:walletwatch/components/my_card.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:walletwatch/services/firebase_service.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  String? _selectedCategory;
  double? _cost;
  String? _selectedType;
  String? _remarks;
  DateTime? _selectedDateTime;
  XFile? _receiptImage;
  File? _image; // Add this line

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: Text('Select Category'),
              items: [
                'Salary',
                'Shopping',
                'Home Bill',
                'Entertainment',
                'Food',
                'Friends'
              ].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _cost = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            Row(
              children: [
                Text('Type: '),
                Radio<String>(
                  value: 'Income',
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                Text('Income'),
                Radio<String>(
                  value: 'Expense',
                  groupValue: _selectedType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                Text('Expense'),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Remarks (optional)'),
              onChanged: (value) {
                setState(() {
                  _remarks = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                _selectDateTime(context);
              },
              child: Text(_selectedDateTime == null
                  ? 'Select Date and Time'
                  : 'Selected Date and Time: ${DateFormat.yMd().add_jm().format(_selectedDateTime!)}'),
            ),
            ElevatedButton(
              onPressed: () {
                _getImage(); // Call the _getImage method to open the image picker
              },
              child: Text('Select Receipt Image'),
            ),
            _receiptImage != null
                ? Image.file(
                    File(_receiptImage!.path)) // Display the selected image
                : Container(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Upload image to Firebase Storage
            String imageUrl = '';
            if (_image != null) {
              final FirebaseStorage storage = FirebaseStorage.instance;
              final Reference ref = storage.ref().child(
                  'transaction_images/${DateTime.now().millisecondsSinceEpoch}');
              final UploadTask uploadTask = ref.putFile(_image!);
              final TaskSnapshot downloadUrl = (await uploadTask);
              imageUrl = await downloadUrl.ref.getDownloadURL();
            }

            // Save transaction details to Firebase Database
            DatabaseReference transactionsRef =
                FirebaseDatabase.instance.reference().child('transactions');
            transactionsRef.push().set({
              'category': _selectedCategory,
              'cost': _cost,
              'type': _selectedType,
              'remarks': _remarks,
              'dateTime': _selectedDateTime != null
                  ? _selectedDateTime!.toIso8601String()
                  : null,
              'imageUrl': imageUrl, // Store image download URL
            }).then((_) {
              // Transaction saved successfully, close the dialog
              Navigator.of(context).pop();
            }).catchError((error) {
              // Handle any errors that occur during saving
              print("Error saving transaction: $error");
              // Optionally, you can show an error message to the user
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // Open gallery to pick image
    if (image != null) {
      setState(() {
        _receiptImage = image; // Set the selected image file
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}

class AddTransactionDialog extends StatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _HomePageState extends State<HomePage> {
  // Retrieve the current user or default to null if not signed in
  final user = FirebaseAuth.instance.currentUser;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseService firebaseService =
      FirebaseService(); // Instantiate FirebaseService

  final pgcontroller = PageController();
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTotalsFromFirebase();
  }

  Future<void> fetchTotalsFromFirebase() async {
    try {
      var transactions = await firebaseService.fetchDataFromFirebase();

      // Calculate total income and total expense
      double income = 0.0;
      double expense = 0.0;
      for (var transaction in transactions) {
        if (transaction['type'] == 'Income') {
          income += transaction['cost'];
        } else if (transaction['type'] == 'Expense') {
          expense += transaction['cost'];
        }
      }

      // Update state with calculated totals
      setState(() {
        totalIncome = income;
        totalExpense = expense;
      });
    } catch (error) {
      print('Error fetching totals: $error');
      print('Error fetching totals: $error');
      // Re-throw the error for higher-level handling
      throw error;
    }
  }

  // Sign out user
  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
              onTap: () {})), // Replace LoginPage with your actual login page
    );
  }

  // Method to handle adding a transaction
  void addTransaction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTransactionDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: addTransaction, // Call addTransaction method
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home),
                iconSize: 40,
                color: Colors.blue[300],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
                iconSize: 40,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //appBar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "My ",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Wallet",
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),

                    //logout button
                    GestureDetector(
                      onTap: () {
                        signUserOut(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(66, 165, 245, 1),
                            shape: BoxShape.circle),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            signUserOut(context);
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),

              //cards
              Container(
                height: 170,
                child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: pgcontroller,
                    children: [
                      MyCard(
                        type: 'Balance',
                        balance: totalIncome - totalExpense,
                        color: Colors.blue[400]!,
                      ),
                      MyCard(
                        type: 'Expense',
                        balance: totalExpense,
                        color: Colors.green[300]!,
                      ),
                    ]),
              ),

              SizedBox(
                height: 20,
              ),
              SmoothPageIndicator(
                  controller: pgcontroller,
                  count: 2,
                  effect: SwapEffect(
                    activeDotColor: Colors.blue,
                  )),
              SizedBox(
                height: 20,
              ),

              //buttons of bills
              List(
                  name: 'Statistics',
                  img: Image.asset('lib/image/stat.png'),
                  desc: 'Payment and Income Chart',
                  onTap: () {
                    Navigator.pushNamed(context, '/statistics');
                  }),

              List(
                  name: 'Transaction',
                  img: Image.asset('lib/image/cash-flow.png'),
                  desc: 'Transaction History',
                  onTap: () {
                    Navigator.pushNamed(context, '/transaction');
                  }),

              List(
                  name: 'Reciepts',
                  img: Image.asset('lib/image/bill.png'),
                  desc: 'Bill of transactions',
                  onTap: () {
                    Navigator.pushNamed(context, '/receipt');
                  }),

              //column for statistics and transactions
              //
            ],
          ),
        ),
      ),
    );
  }
}
