import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/AuthService.dart';
import 'package:flutter_project/Pages/angry_page.dart';
import 'package:flutter_project/Pages/happy_page.dart';
import 'package:flutter_project/Pages/sad_page.dart';
import 'package:flutter_project/Pages/AuthScreen.dart';

class MoodSelectionPage extends StatelessWidget {
  const MoodSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Mood Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
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
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      padding: const EdgeInsets.all(20),
      children: [
        _buildMoodTile(context, '😡', 'Angry', const AngryPage(), Colors.red),
        _buildMoodTile(context, '😢', 'Sad', const SadPage(), Colors.blue),
        _buildMoodTile(
            context, '😊', 'Happy', const HappyPage(), Colors.yellow),
        _buildMoodTile(
            context, '😌', 'Relaxed', const HappyPage(), Colors.green),
      ],
    );
  }

  Widget _buildMoodTile(BuildContext context, String emoji, String label,
      Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        // Navigate to the corresponding page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        color: color.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 10),
            Text(label,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
