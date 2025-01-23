import 'package:flutter/material.dart';

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
        child: MoodGrid(), // Use the MoodGrid widget for the mood selection
      ),
    );
  }
}

class MoodGrid extends StatefulWidget {
  const MoodGrid({super.key});

  @override
  _MoodGridState createState() => _MoodGridState();
}

class _MoodGridState extends State<MoodGrid> {
  String _selectedMood = ''; // Store the selected mood

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Three columns for mood selection
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                return _buildMoodEmoji(
                    _moods[index].emoji, _moods[index].label);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Moods list that can be easily extended
  List<Mood> get _moods => [
        Mood('😡', 'Angry'),
        Mood('😢', 'Sad'),
        Mood('😊', 'Happy'),
      ];

  // Dialog to show the selected mood
  void _showMoodDialog(BuildContext context, String mood) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mood Selected'),
          content: Text('You selected the mood: $mood'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to create a mood button with an emoji and label
  Widget _buildMoodEmoji(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        _showMoodDialog(context, label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.2), // Add temporary scale effect
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 60,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mood class to easily represent mood with an emoji and a label
class Mood {
  final String emoji;
  final String label;

  Mood(this.emoji, this.label);
}
