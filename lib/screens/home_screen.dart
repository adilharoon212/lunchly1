import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:lunchly1/utils/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable to simulate the end of voting
  bool votingEnded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      ),
      body: Column(
        children: [
          TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
            DateTime now = DateTime.now();
            DateTime votingStartTime =
                DateTime(now.year, now.month, now.day, 17, 0, 0);
            DateTime votingEndTime =
                DateTime(now.year, now.month, now.day, 23, 0, 0);

            Duration remainingTime;

            if (votingEnded) {
              return _buildVotingEndedMessage();
            } else if (now.isAfter(votingEndTime)) {
              setState(() {
                votingEnded = true;
              });
              return _buildVotingEndedMessage();
            } else if (now.isBefore(votingStartTime)) {
              remainingTime = votingStartTime.difference(now);
            } else {
              remainingTime = votingEndTime.difference(now);
            }

            return _buildVotingCountdown(remainingTime);
          }),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 243, 223, 223),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWelcomeMessage(),
                      SizedBox(height: 20),
                      _buildMenuVotingButton(context),
                      SizedBox(height: 20),
                      _buildPlaceOrderButton(context),
                      SizedBox(height: 20),
                      _buildDonateButton(context),
                      SizedBox(height: 20),
                      _buildEndVotingButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildDrawerHeader(),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVotingCountdown(Duration remainingTime) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Voting Ends In: ${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildVotingEndedMessage() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Voting Has Ended',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Text(
      "Welcome to Lunchly!",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildMenuVotingButton(BuildContext context) {
    return _buildActionButton(
      "Menu Voting",
      () => _handleMenuVotingButtonTap(context),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return _buildActionButton(
      "Place Order",
      () => _handlePlaceOrderButtonTap(context),
    );
  }

  Widget _buildDonateButton(BuildContext context) {
    return _buildActionButton(
      "Donate",
      () => _handleDonateButtonTap(context),
    );
  }

  Widget _buildEndVotingButton() {
    return _buildActionButton(
      "End Voting",
      _handleEndVotingButtonTap,
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        'Preview',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Logout',
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
      },
    );
  }

  void _handleMenuVotingButtonTap(BuildContext context) {
    if (votingEnded) {
      _showVotingEndedDialog(context);
    } else {
      Navigator.pushNamed(context, MyRoutes.voteRoute);
    }
  }

  void _handlePlaceOrderButtonTap(BuildContext context) {
    Navigator.pushNamed(context, MyRoutes.placeorderRoute);
  }

  void _handleDonateButtonTap(BuildContext context) {
    Navigator.pushNamed(context, MyRoutes.donateRoute);
  }

  void _handleEndVotingButtonTap() {
    DateTime now = DateTime.now();
    DateTime votingEndTime = DateTime(now.year, now.month, now.day, 23, 0, 0);

    // Only simulate the end of voting if the current time is before the voting end time
    if (now.isBefore(votingEndTime)) {
      setState(() {
        votingEnded = true;
      });
    }
  }

  void _showVotingEndedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Voting has ended"),
          content: Text("You can now place your order."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
