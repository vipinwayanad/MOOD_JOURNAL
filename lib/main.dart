import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/angry_page.dart';
import 'package:flutter_project/Pages/happy_page.dart';
import 'package:flutter_project/Pages/sad_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MoodSelectionPage(),
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
    var happyPage = HappyPage();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: <Widget>[
          _buildMoodTile(context, '😡', 'Angry',
              AngryPage()), // Angry button navigates to AngryPage
          _buildMoodTile(context, '😢', 'Sad',
              SadPage()), // Sad button navigates to SadPage
          _buildMoodTile(context, '😊', 'Happy',
              HappyPage()), // Happy button navigates to HappyPage
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
