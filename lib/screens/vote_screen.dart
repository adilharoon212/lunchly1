import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lunchly1/utils/routes.dart';

class VoteScreen extends StatefulWidget {
  final DateTime votingEndTime;

  VoteScreen({required this.votingEndTime});

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  List<String> menuItems = [
    'Biryani',
    'Nihari',
    'Haleem',
    'Chapli Kebab',
    'Samosa',
    'Karhai Gosht',
    'Seekh Kebab',
    'Aloo Keema',
    'Saag',
    'Jalebi',
  ];

  Map<String, int> votes = {};
  Map<String, int> peopleVotedCounts =
      {}; // Map to store people voted count for each item
  String? userVotedItem;

  CollectionReference votesCollection =
      FirebaseFirestore.instance.collection('user_votes');
  CollectionReference voteMenuItemCollection =
      FirebaseFirestore.instance.collection('votemenuitem');

  List<String> getTopVotedItems(int count) {
    List<String> sortedItems = votes.keys.toList()
      ..sort((a, b) => (votes[b] ?? 0).compareTo(votes[a] ?? 0));

    return sortedItems.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote Menu'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.redAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: voteMenuItemCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, int> realTimeVotes = {};
          Map<String, int> realTimePeopleVotedCounts = {};

          // Update real-time votes and people voted counts from Firestore snapshot
          snapshot.data!.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data.forEach((key, value) {
              if (menuItems.contains(key)) {
                realTimeVotes[key] = value as int;

                // Retrieve and update people voted count for each item
                int? count = data['$key\_count'];
                if (count != null) {
                  realTimePeopleVotedCounts[key] = count;
                }
              }
            });
          });

          votes = realTimeVotes;
          peopleVotedCounts = realTimePeopleVotedCounts;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 243, 223, 223),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                String menuItem = menuItems[index];
                int voteCount = votes[menuItem] ?? 0;
                int peopleVotedCount = peopleVotedCounts[menuItem] ?? 0;

                return _buildVoteItem(menuItem, voteCount, peopleVotedCount);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _saveVotesToDatabase();
          Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
        },
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildVoteItem(String itemName, int voteCount, int peopleVotedCount) {
    bool hasVoted = userVotedItem == itemName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Vote Here',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.local_dining, color: Colors.orangeAccent),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      itemName,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Container(
                height: 30.0,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: FractionallySizedBox(
                  widthFactor: voteCount / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.star,
                            color: hasVoted ? Colors.amber : Colors.grey),
                        onPressed: () {
                          _voteForItem(itemName);
                        },
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.star_border,
                            color: hasVoted ? Colors.grey : Colors.amber),
                        onPressed: () {
                          _unvoteForItem(itemName);
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '$voteCount',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 8.0),
                      Text(
                        '$peopleVotedCount',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _voteForItem(String itemName) {
    setState(() {
      userVotedItem = itemName;
      votes[itemName] = (votes[itemName] ?? 0) + 1;
      peopleVotedCounts[itemName] = (peopleVotedCounts[itemName] ?? 0) + 1;
    });
  }

  void _unvoteForItem(String itemName) {
    setState(() {
      userVotedItem = null;
      votes[itemName] = (votes[itemName] ?? 0) - 1;
      peopleVotedCounts[itemName] = (peopleVotedCounts[itemName] ?? 0) - 1;
    });
  }

  Future<void> _saveVotesToDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && userVotedItem != null) {
      // Save user's vote
      await votesCollection.doc(user.uid).set({
        'votedItem': userVotedItem,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the vote count for the selected item
      await voteMenuItemCollection.doc(userVotedItem!).set({
        userVotedItem!: (votes[userVotedItem!] ?? 0) + 1,
        '${userVotedItem!}_count': (peopleVotedCounts[userVotedItem!] ?? 0) + 1,
      }, SetOptions(merge: true));
    }
  }
}
