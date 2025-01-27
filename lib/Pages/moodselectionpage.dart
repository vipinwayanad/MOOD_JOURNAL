import 'package:flutter/material.dart';
import 'AuthService.dart';
import 'angry_page.dart';
import 'happy_page.dart';
import 'sad_page.dart';
import 'AuthScreen.dart';

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
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: [
        _buildMoodTile(context, '😡', 'Angry', const AngryPage()),
        _buildMoodTile(context, '😢', 'Sad', const SadPage()),
        _buildMoodTile(context, '😊', 'Happy', const HappyPage()),
      ],
    );
  }

  Widget _buildMoodTile(
      BuildContext context, String emoji, String label, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
