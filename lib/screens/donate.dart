import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  TextEditingController _lunchboxController = TextEditingController();
  int _numberOfLunchboxes = 0;
  List<int> donationHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Donate'),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLunchboxInput(),
          SizedBox(height: 20),
          _buildDonateButton(),
          SizedBox(height: 20),
          _buildDonationHistory(),
        ],
      ),
    );
  }

  Widget _buildLunchboxInput() {
    return TextField(
      controller: _lunchboxController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Number of Lunchboxes',
      ),
    );
  }

  Widget _buildDonateButton() {
    return ElevatedButton(
      onPressed: _onDonatePressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }
            return Colors.transparent;
          },
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Donate',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonationHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donation History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildDonationList(),
      ],
    );
  }

  Widget _buildDonationList() {
    return Column(
      children: donationHistory.map((donation) {
        return ListTile(
          title: Text('Donated $donation lunchboxes'),
          // Add more information or styling as needed
        );
      }).toList(),
    );
  }

  void _onDonatePressed() async {
    if (_lunchboxController.text.isNotEmpty) {
      _numberOfLunchboxes = int.parse(_lunchboxController.text);
      await _performDonation();
      _updateDonationHistory();
      _showConfirmationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid number of lunchboxes.'),
        ),
      );
    }
  }

  Future<void> _performDonation() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Redirect to login or handle unauthenticated user
        return;
      }

      // Create a new donation object
      Donation donation = Donation(
        userId: user.uid,
        amount: _numberOfLunchboxes,
        timestamp: DateTime.now(),
      );

      // Store donation in Firestore
      await FirebaseFirestore.instance
          .collection('donations')
          .add(donation.toMap());
    } catch (e) {
      print('Error performing donation: $e');
      // Handle donation error, e.g., show an error message
    }
  }

  void _updateDonationHistory() async {
    try {
      // Fetch and display donation history from Firestore
      QuerySnapshot donationSnapshot =
          await FirebaseFirestore.instance.collection('donations').get();
      List<Donation> donations = donationSnapshot.docs
          .map((doc) => Donation.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        donationHistory = donations.map((donation) => donation.amount).toList();
      });
    } catch (e) {
      print('Error updating donation history: $e');
      // Handle error, e.g., show an error message
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Donation'),
          content: Text(
              'Are you sure you want to donate $_numberOfLunchboxes lunchboxes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Donate'),
            ),
          ],
        );
      },
    );
  }
}

class Donation {
  final String userId;
  final int amount;
  final DateTime timestamp;

  Donation({
    required this.userId,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'timestamp': timestamp.toUtc(),
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      userId: map['userId'],
      amount: map['amount'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
