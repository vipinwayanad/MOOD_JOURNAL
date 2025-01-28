import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

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

  final String clientId = "2fed2165f5de4973900d8d33d10000d3";
  final String clientSecret = "f030551d371748c1a33b7d2b03f44fb1";
  final String redirectUri = "musicapp://callback"; // Use your redirect URI

  String? accessToken;

  @override
  void initState() {
    super.initState();
    _generateMotivation();
  }

  // Fetch motivational quote from the API
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

  // Update the motivational quote and advice
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

  // Virtual Game to decrease anger (bubble popping)
  void _playVirtualGame() {
    setState(() {
      if (angerLevel > 0) {
        angerLevel -= 10; // Decrease anger level by 10 on each interaction
      } else {
        angerLevel = 0;
      }
    });
  }

  // Spotify Authentication and Play Music
  Future<void> authenticateSpotify() async {
    final String authUrl =
        'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=user-library-read playlist-read-private';

    try {
      final result = await FlutterWebAuth.authenticate(
          url: authUrl, callbackUrlScheme: "musicapp");

      final Uri uri = Uri.parse(result);
      final String? code = uri.queryParameters['code'];

      if (code != null) {
        final response = await http.post(
          Uri.parse('https://accounts.spotify.com/api/token'),
          headers: {
            'Authorization':
                'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': redirectUri,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            accessToken = data['access_token'];
          });
        } else {
          throw Exception('Failed to get access token');
        }
      }
    } catch (e) {
      setState(() {
        accessToken = null; // Handle failed authentication
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication Failed. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _launchSpotifyPlayer(String playlistUrl) async {
    final url = Uri.parse(playlistUrl);

    // Checking if the link can be launched by the device
    if (await canLaunch(url.toString())) {
      await launch(url.toString()); // Launch Spotify playlist
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        title: const Text('Anger Management & Motivation'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You're feeling angry! Let's work through it.",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Reason for anger
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "What made you angry?",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Lifestyle factors (Checkboxes)
              CheckboxListTile(
                title: const Text("Are you an alcoholic?"),
                value: isAlcoholic,
                onChanged: (value) {
                  setState(() {
                    isAlcoholic = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Do you smoke?"),
                value: isSmoker,
                onChanged: (value) {
                  setState(() {
                    isSmoker = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Do you have poor sleep habits?"),
                value: hasPoorSleep,
                onChanged: (value) {
                  setState(() {
                    hasPoorSleep = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Do you skip exercise?"),
                value: skipsExercise,
                onChanged: (value) {
                  setState(() {
                    skipsExercise = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Tasks
              CheckboxListTile(
                title: const Text("Task 1: Take 5 deep breaths."),
                value: task1Completed,
                onChanged: (value) {
                  setState(() {
                    task1Completed = value!;
                    if (value) angerLevel -= 10;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Task 2: Take a 5-minute walk."),
                value: task2Completed,
                onChanged: (value) {
                  setState(() {
                    task2Completed = value!;
                    if (value) angerLevel -= 10;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Anger level slider
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
              const SizedBox(height: 20),
              // Virtual Game Section (Bubble Pop Game)
              Center(
                child: ElevatedButton(
                  onPressed: _playVirtualGame,
                  child: const Text("Pop a Bubble (Decrease Anger)"),
                ),
              ),
              const SizedBox(height: 20),
              // Get Motivated Button
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
                ),
              ),
              const SizedBox(height: 20),
              // Spotify Authentication and Play Music Button
              Center(
                child: ElevatedButton(
                  onPressed: authenticateSpotify,
                  child: const Text("Connect to Spotify"),
                ),
              ),
              if (accessToken != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String playlistUri =
                        "spotify:playlist:26XqtARCz3j3L3ICTn42Dq"; // Replace with actual playlist URI
                    _launchSpotifyPlayer(playlistUri);
                  },
                  child: const Text("Play Calming Music"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
