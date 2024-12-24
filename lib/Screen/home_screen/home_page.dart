import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the username from Firestore (replace 'users' with your collection name)
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          username = userDoc['name'] ?? "User";
        });
      } else {
        setState(() {
          username = "Guest";
        });
      }
    } catch (e) {
      print("Error fetching username: $e");
      setState(() {
        username = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // Replace with actual profile image URL
              ),
            ),
            const SizedBox(width: 10),
            Text(username),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu actions
              print("Selected: $value");
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: "Profile", child: Text("Profile")),
              const PopupMenuItem(value: "Settings", child: Text("Settings")),
              const PopupMenuItem(value: "Help", child: Text("Help")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to the Dashboard!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Map Screen
                Navigator.pushNamed(context, '/mapscreen');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                "Open Map",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Handle emergency contact action
                print("Emergency Contact Pressed");
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.contact_phone, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Handle AI assistance action
                print("AI Assistance Pressed");
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
