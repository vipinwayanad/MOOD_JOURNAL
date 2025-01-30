import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class YouTubeService {
  final String apiKey =
      'YOUR_YOUTUBE_API_KEY'; // Replace with your actual API key

  Future<List<String>> fetchRandomVideos(String mood) async {
    String searchQuery = '';

    switch (mood) {
      case 'angry':
        searchQuery = 'anger management';
        break;
      case 'happy':
        searchQuery = 'motivational';
        break;
      case 'sad':
        searchQuery = 'uplifting';
        break;
      default:
        searchQuery = 'motivational';
    }

    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$searchQuery&key=$apiKey&type=video&maxResults=5'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> videoIds = [];

      for (var item in data['items']) {
        videoIds.add(item['id']['videoId']);
      }
      return videoIds;
    } else {
      throw Exception('Failed to load videos');
    }
  }
}

class AngryPage extends StatefulWidget {
  const AngryPage({super.key});

  @override
  _AngryPageState createState() => _AngryPageState();
}

class _AngryPageState extends State<AngryPage> {
  final TextEditingController _reasonController = TextEditingController();
  double angerLevel = 100;
  bool isAlcoholic = false;
  bool isSmoker = false;
  bool hasPoorSleep = false;
  bool skipsExercise = false;
  bool task1Completed = false;
  bool task2Completed = false;

  String? selectedQuote;
  String? selectedAdvice;
  String? imageUrl;
  final List<String> emotions = [];

  @override
  void initState() {
    super.initState();
    _generateMotivation();
    _fetchMotivationalImage();
  }

  Future<void> _fetchMotivationalImage() async {
    const String accessKey =
        'YOUR_UNSPLASH_ACCESS_KEY'; // Replace with your actual access key
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?query=anger&client_id=$accessKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['urls']['regular'];
      });
    }
  }

  Future<String> fetchMotivationalQuote() async {
    final response = await http
        .get(Uri.parse('https://api.quotable.io/random?tags=inspire'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['content'];
    } else {
      throw Exception('Failed to load quote');
    }
  }

  Future<void> _generateMotivation() async {
    try {
      String quote = await fetchMotivationalQuote();
      setState(() {
        selectedQuote = quote;
      });
    } catch (e) {
      setState(() {
        selectedQuote = "Stay strong, better days are ahead!";
      });
    }

    final random = Random();
    List<String> adviceList = [
      "Try journaling your thoughts to better understand your emotions.",
      "A quick meditation can help calm your mind. Try it now!",
      "Drink a glass of water—it’s a small, refreshing reset.",
      "Engage in your favorite hobby for 15 minutes.",
      "Talk to someone you trust. Sharing helps lighten the burden.",
      "Take a moment to count 5 things you’re grateful for.",
    ];

    setState(() {
      selectedAdvice = adviceList[random.nextInt(adviceList.length)];
    });
  }

  void _playVirtualGame() {
    setState(() {
      if (angerLevel > 0) {
        angerLevel -= 10;
      } else {
        angerLevel = 0;
      }
    });
  }

  void _submitEmotions() {
    // For demonstration purposes, just print emotions
    print("User Emotions: $emotions");

    // Here you would normally send the emotions to your database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Anger Management & Motivation'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "You're feeling angry! Let's work through it.",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: "What made you angry?",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.all(10),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              "Describe your emotions:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildEmotionSurvey(),
            const SizedBox(height: 20),
            const Text(
              "Lifestyle Check:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildLifestyleCheckboxes(),
            const SizedBox(height: 20),
            const Text(
              "Tasks:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTasks(),
            const SizedBox(height: 20),
            _buildAngerLevelSlider(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _playVirtualGame,
                child: const Text("Pop a Bubble (Decrease Anger)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _generateMotivation();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Your Path to Happiness"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Here’s something to brighten your mood:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            selectedQuote ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "And here’s a helpful piece of advice:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            selectedAdvice ?? '',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("Get Motivated!"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitEmotions();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AngryVideoPage(),
                    ),
                  );
                },
                child: const Text("Watch Motivational Video"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionSurvey() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text("Frustrated"),
          value: emotions.contains("Frustrated"),
          onChanged: (value) {
            setState(() {
              if (value == true)
                emotions.add("Frustrated");
              else
                emotions.remove("Frustrated");
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Overwhelmed"),
          value: emotions.contains("Overwhelmed"),
          onChanged: (value) {
            setState(() {
              if (value == true)
                emotions.add("Overwhelmed");
              else
                emotions.remove("Overwhelmed");
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Anxious"),
          value: emotions.contains("Anxious"),
          onChanged: (value) {
            setState(() {
              if (value == true)
                emotions.add("Anxious");
              else
                emotions.remove("Anxious");
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Sad"),
          value: emotions.contains("Sad"),
          onChanged: (value) {
            setState(() {
              if (value == true)
                emotions.add("Sad");
              else
                emotions.remove("Sad");
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Angry"),
          value: emotions.contains("Angry"),
          onChanged: (value) {
            setState(() {
              if (value == true)
                emotions.add("Angry");
              else
                emotions.remove("Angry");
            });
          },
        ),
      ],
    );
  }

  Widget _buildLifestyleCheckboxes() {
    return Column(
      children: [
        _customCheckbox("Are you an alcoholic?", isAlcoholic, (value) {
          setState(() {
            isAlcoholic = value!;
          });
        }),
        _customCheckbox("Do you smoke?", isSmoker, (value) {
          setState(() {
            isSmoker = value!;
          });
        }),
        _customCheckbox("Do you have poor sleep habits?", hasPoorSleep,
            (value) {
          setState(() {
            hasPoorSleep = value!;
          });
        }),
        _customCheckbox("Do you skip exercise?", skipsExercise, (value) {
          setState(() {
            skipsExercise = value!;
          });
        }),
      ],
    );
  }

  Widget _customCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: CheckboxListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.redAccent,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildTasks() {
    return Column(
      children: [
        _taskCard("Task 1: Take 5 deep breaths.", task1Completed, (value) {
          setState(() {
            task1Completed = value!;
            if (value) angerLevel -= 10;
          });
        }),
        _taskCard("Task 2: Take a 5-minute walk.", task2Completed, (value) {
          setState(() {
            task2Completed = value!;
            if (value) angerLevel -= 10;
          });
        }),
        _taskCard("Task 3: Write down your feelings.", task1Completed, (value) {
          setState(() {
            task1Completed = value!;
            if (value) angerLevel -= 10;
          });
        }),
        _taskCard("Task 4: Listen to calming music.", task2Completed, (value) {
          setState(() {
            task2Completed = value!;
            if (value) angerLevel -= 10;
          });
        }),
      ],
    );
  }

  Widget _taskCard(String title, bool completed, Function(bool?) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: CheckboxListTile(
        title: Text(title),
        value: completed,
        onChanged: onChanged,
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildAngerLevelSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Adjust your anger level:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Slider(
          value: angerLevel,
          min: 0,
          max: 100,
          divisions: 10,
          label: "${angerLevel.toStringAsFixed(1)}%",
          onChanged: (value) {
            setState(() {
              angerLevel = value;
            });
          },
        ),
      ],
    );
  }
}

class AngryVideoPage extends StatelessWidget {
  const AngryVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Angry Management Videos'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final youTubeService = YouTubeService();
            try {
              List<String> videoIds =
                  await youTubeService.fetchRandomVideos('angry');
              if (videoIds.isNotEmpty) {
                final String videoUrl =
                    'https://www.youtube.com/watch?v=${videoIds[0]}';
                if (await canLaunch(videoUrl)) {
                  await launch(videoUrl);
                } else {
                  throw 'Could not launch $videoUrl';
                }
              }
            } catch (e) {
              print('Error: $e'); // Handle errors
            }
          },
          child: const Text('Click here to watch a video'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          ),
        ),
      ),
    );
  }
}
