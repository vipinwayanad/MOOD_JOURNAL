import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HappyPage extends StatefulWidget {
  const HappyPage({super.key});

  @override
  _HappyPageState createState() => _HappyPageState();
}

class _HappyPageState extends State<HappyPage> {
  final TextEditingController _reasonController = TextEditingController();
  String motivationMessage =
      "Keep the happiness flowing! What made you happy today?";
  String taskMessage =
      "Take a moment to reflect on your accomplishments today!";
  String funQuestion =
      "What's your favorite way to spread happiness to others?";
  String funAnswer = '';
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

  // Fetch random happy-themed image from Unsplash
  Future<void> _fetchRandomImage() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos/random?query=happiness&client_id=$_unsplashApiKey'));
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

  // Fetch random happy-themed video from YouTube
  Future<void> _fetchHappyMoodVideo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=happy+music&type=video&key=$_youtubeApiKey'));
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
                'Stay Happy',
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
                // Section: Share Your Happiness
                _buildSectionTitle('Share Your Happiness'),
                TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: "What made you happy today?",
                    border: OutlineInputBorder(),
                    hintText: "Share your happiness!",
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_reasonController.text.isNotEmpty) {
                      setState(() {
                        motivationMessage =
                            "Thank you for sharing! Let's keep the happiness going!";
                      });
                    }
                  },
                  child: Text('Submit Happiness'),
                ),
                SizedBox(height: 16),
                Text(
                  motivationMessage,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),

                // Section: Reflect on Your Achievements
                _buildSectionTitle('Reflect on Your Achievements'),
                _buildTaskCard(
                  'Reflect on Your Day',
                  'Take a moment to think about what you accomplished today.',
                  isTaskCompleted,
                  () {
                    setState(() {
                      isTaskCompleted = true;
                      taskMessage =
                          "Great job! You reflected on your accomplishments. Keep it up!";
                    });
                  },
                ),

                // Section: Spread Happiness
                _buildSectionTitle('Spread Happiness'),
                Text(
                  funQuestion,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      funAnswer = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Your answer",
                    border: OutlineInputBorder(),
                    hintText: "Share with us...",
                  ),
                ),
                SizedBox(height: 16),
                if (funAnswer.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        questionAnswered = true;
                        motivationMessage =
                            "You're doing amazing! Keep spreading happiness!";
                      });
                    },
                    child: Text('Next Step'),
                  ),

                // Section: Activities to Stay Happy
                _buildSectionTitle('Activities to Stay Happy'),
                ..._happyActivities.map((activity) => _buildTaskCard(
                      activity,
                      'Engage in this activity to boost your happiness.',
                      false,
                      () {
                        // Handle activity completion
                      },
                    )),

                // Section: Watch a Happy Video
                _buildSectionTitle('Watch a Happy Video'),
                ElevatedButton(
                  onPressed: _fetchHappyMoodVideo,
                  child: Text('Watch a Happy Video'),
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

  // List of happy activities
  final List<String> _happyActivities = [
    "Listen to your favorite music",
    "Write down three things you're grateful for",
    "Call a friend or family member",
    "Go for a walk in nature",
    "Watch a comedy show or movie",
    "Do something kind for someone else",
    "Practice mindfulness or meditation",
    "Dance like nobody's watching",
    "Cook or bake something delicious",
    "Spend time with a pet",
  ];
}
