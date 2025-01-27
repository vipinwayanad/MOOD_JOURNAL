import 'dart:math';

import 'package:flutter/material.dart';

class AngryPage extends StatefulWidget {
  const AngryPage({super.key});

  @override
  _AngryPageState createState() => _AngryPageState();
}

class _AngryPageState extends State<AngryPage> {
  // Existing variables
  final TextEditingController _reasonController = TextEditingController();
  double angerLevel = 100;
  bool isAlcoholic = false;
  bool isSmoker = false;
  bool hasPoorSleep = false;
  bool skipsExercise = false;
  bool task1Completed = false;
  bool task2Completed = false;

  // Motivational and advice variables
  List<String> motivationalQuotes = [
    "You’re stronger than you think!",
    "Every storm runs out of rain. Stay strong!",
    "Take it one day at a time, and you’ll get there.",
    "Focus on the positives, and let go of the negatives.",
    "Smiling is contagious—spread it around!",
    "This is just a moment; happiness is on its way.",
  ];

  List<String> adviceList = [
    "Try journaling your thoughts to better understand your emotions.",
    "A quick meditation can help calm your mind. Try it now!",
    "Drink a glass of water—it’s a small, refreshing reset.",
    "Engage in your favorite hobby for 15 minutes.",
    "Talk to someone you trust. Sharing helps lighten the burden.",
    "Take a moment to count 5 things you’re grateful for.",
  ];

  String? selectedQuote;
  String? selectedAdvice;

  @override
  void initState() {
    super.initState();
    _generateMotivation();
  }

  // Randomly pick a motivational quote and advice
  void _generateMotivation() {
    final random = Random();
    setState(() {
      selectedQuote =
          motivationalQuotes[random.nextInt(motivationalQuotes.length)];
      selectedAdvice = adviceList[random.nextInt(adviceList.length)];
    });
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
              // Lifestyle factors
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
            ],
          ),
        ),
      ),
    );
  }
}
