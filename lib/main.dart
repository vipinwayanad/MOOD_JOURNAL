import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/Pages/AuthScreen.dart';
import 'package:flutter_project/Pages/AuthService.dart';
import 'package:flutter_project/Pages/angry_page.dart';
import 'package:flutter_project/Pages/happy_page.dart';
import 'package:flutter_project/Pages/sad_page.dart';

// Firebase Configuration for Web
const FirebaseOptions firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyAkB2CTX2-BJf91BGTF_el24keAklaIR_Y",
  authDomain: "mood-journal-bac33.firebaseapp.com",
  projectId: "mood-journal-bac33",
  storageBucket: "mood-journal-bac33.firebasestorage.app",
  messagingSenderId: "803397693598",
  appId: "1:803397693598:web:be1dac36f6b307c6b4cb8f",
  measurementId: "G-B593BR7FKQ", // Optional for analytics
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with configuration for web
  await Firebase.initializeApp(options: firebaseConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Journal with Authentication',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreen(), // Start with the authentication screen
    );
  }
}

class MoodSelectionPage extends StatelessWidget {
  const MoodSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Mood Journal'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout(); // Logout user
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MoodSelectionPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: MoodGrid(),
      ),
    );
  }
}

class MoodGrid extends StatelessWidget {
  const MoodGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: <Widget>[
          _buildMoodTile(context, '😡', 'Angry', const AngryPage()),
          _buildMoodTile(context, '😢', 'Sad', const SadPage()),
          _buildMoodTile(context, '😊', 'Happy', const HappyPage()),
        ],
      ),
    );
  }

  Widget _buildMoodTile(
      BuildContext context, String emoji, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => page), // Navigate to specific mood page
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            emoji,
            style: const TextStyle(fontSize: 60),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
//unsplash-  bL6s4kXPfee8uSi4t7FmrDN-aRiIhi74gzc3JvSzIDA
//youtube-  AIzaSyBm7q1ZxdL0gdydT9zemvtuw-t9WhR0GZI
