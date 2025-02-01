import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SadPage extends StatefulWidget {
  const SadPage({super.key});

  @override
  _SadPageState createState() => _SadPageState();
}

class _SadPageState extends State<SadPage> {
  final TextEditingController _reasonController = TextEditingController();
  String motivationMessage =
      "It's okay to feel sad. Let's work together to uplift your mood.";
  String taskMessage = "Take a moment to reflect and complete these tasks.";
  String reflectionQuestion =
      "What's one thing you can do to feel better right now?";
  String reflectionAnswer = '';
  bool isTaskCompleted = false;
  bool questionAnswered = false;

  // Unsplash API State
  String _imageUrl = '';
  String? _unsplashApiKey;

  // YouTube API State
  String _videoUrl = '';
  String? _youtubeApiKey;

  @override
  void initState() {
    super.initState();
    _unsplashApiKey = dotenv.env['UNSPLASH_API_KEY'];
    _youtubeApiKey = dotenv.env['YOUTUBE_API_KEY'];
    _fetchRandomImage();
  }

  // Fetch random sad-themed image from Unsplash
  Future<void> _fetchRandomImage() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos/random?query=sad&client_id=$_unsplashApiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _imageUrl = data['urls']['regular'];
        });
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  // Fetch random calming video from YouTube
  Future<void> _fetchCalmingVideo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=calming+music&type=video&key=$_youtubeApiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoId = data['items'][0]['id']['videoId'];
        setState(() {
          _videoUrl = 'https://www.youtube.com/watch?v=$videoId';
        });
      }
    } catch (e) {
      print('Error fetching YouTube video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with background image
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Overcome Sadness',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: _imageUrl.isNotEmpty
                  ? Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ),
          // Main content
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section: Share Your Feelings
                _buildSectionTitle('Share Your Feelings'),
                TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: "What is making you sad?",
                    border: OutlineInputBorder(),
                    hintText: "Share your feelings with us...",
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_reasonController.text.isNotEmpty) {
                      setState(() {
                        motivationMessage =
                            "Thank you for sharing. Let's work on feeling better!";
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 16),
                Text(
                  motivationMessage,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),

                // Section: Reflect and Take Action
                _buildSectionTitle('Reflect and Take Action'),
                _buildTaskCard(
                  'Reflect on Your Feelings',
                  'Take a moment to acknowledge your emotions and understand them.',
                  isTaskCompleted,
                  () {
                    setState(() {
                      isTaskCompleted = true;
                      taskMessage =
                          "Great job! Reflecting on your feelings is the first step to healing.";
                    });
                  },
                ),

                // Section: What Can You Do?
                _buildSectionTitle('What Can You Do?'),
                Text(
                  reflectionQuestion,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      reflectionAnswer = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Your answer",
                    border: OutlineInputBorder(),
                    hintText: "Share with us...",
                  ),
                ),
                SizedBox(height: 16),
                if (reflectionAnswer.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        questionAnswered = true;
                        motivationMessage =
                            "You're taking steps to feel better. Keep going!";
                      });
                    },
                    child: Text('Next Step'),
                  ),

                // Section: Activities to Feel Better
                _buildSectionTitle('Activities to Feel Better'),
                ..._sadActivities.map((activity) => _buildTaskCard(
                      activity,
                      'Engage in this activity to help uplift your mood.',
                      false,
                      () {
                        // Handle activity completion
                      },
                    )),

                // Section: Watch a Calming Video
                _buildSectionTitle('Watch a Calming Video'),
                ElevatedButton(
                  onPressed: _fetchCalmingVideo,
                  child: Text('Watch a Calming Video'),
                ),
                if (_videoUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Video URL: $_videoUrl'),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper method to build task cards
  Widget _buildTaskCard(String title, String description, bool isCompleted,
      VoidCallback onComplete) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(description),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: isCompleted ? null : onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.green : Colors.blue,
              ),
              child: Text(isCompleted ? 'Completed' : 'Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }

  // List of activities to help with sadness
  final List<String> _sadActivities = [
    "Take 5 deep breaths",
    "Write down 3 things you're grateful for",
    "Listen to calming music",
    "Take a 10-minute walk outside",
    "Call or message a friend",
    "Write a letter to yourself",
    "Practice mindfulness or meditation",
    "Watch a comforting movie or show",
    "Do something kind for someone else",
    "Spend time with a pet",
  ];
}
