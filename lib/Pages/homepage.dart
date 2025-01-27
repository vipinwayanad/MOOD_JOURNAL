import 'package:flutter/material.dart';

class MoodSelectionPage extends StatelessWidget {
  const MoodSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Make the background extend behind the AppBar
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mood Journal'),
        centerTitle: true,
        // ignore: deprecated_member_use
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        elevation: 0,
      ),
      body: const MoodSelectionBody(),
    );
  }
}

class MoodSelectionBody extends StatelessWidget {
  const MoodSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purpleAccent,
                  Colors.blueAccent,
                ],
              ),
            ),
          ),
        ),
        // Content
        const Center(
          child: MoodGrid(),
        ),
      ],
    );
  }
}

class MoodGrid extends StatefulWidget {
  const MoodGrid({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MoodGridState createState() => _MoodGridState();
}

class _MoodGridState extends State<MoodGrid> {
// Store the selected mood

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
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
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
        Mood('😐', 'Neutral'),
        Mood('😎', 'Cool'),
        Mood('🥳', 'Excited'),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // ignore: deprecated_member_use
          splashColor: Colors.blueAccent.withOpacity(0.4), // Ripple effect
          highlightColor:
              // ignore: deprecated_member_use
              Colors.blueAccent.withOpacity(0.3), // Highlight effect
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showMoodDialog(context, label);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(1.1), // Slight scale on hover
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 60,
                        fontFamily: 'EmojiOne',
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
            ),
          ),
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
