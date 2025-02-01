import 'package:flutter/material.dart';

class SadPage extends StatefulWidget {
  const SadPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SadPageState createState() => _SadPageState();
}

class _SadPageState extends State<SadPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _gratefulController = TextEditingController();
  String motivationMessage = "It's okay to feel sad. Let's uplift your spirit.";
  bool task1Completed = false;
  bool task2Completed = false;
  bool task3Completed = false;
  bool task4Completed = false;
  bool task5Completed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Overcome Sadness'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                20.0, // Avoid keyboard overlap
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You're feeling Sad. Let's turn that around!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "What is making you sad?",
                  border: OutlineInputBorder(),
                  hintText: "Share your sadness with us",
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSadReason,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              Text(
                motivationMessage,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              // Task checkboxes
              CheckboxListTile(
                title: const Text("Task 1: Take 5 deep breaths."),
                value: task1Completed,
                onChanged: (value) {
                  setState(() {
                    task1Completed = value!;
                    if (value) {
                      motivationMessage =
                          "You’re breathing deeply. Keep it up!";
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text(
                    "Task 2: Listen to calming music for 5 minutes."),
                value: task2Completed,
                onChanged: (value) {
                  setState(() {
                    task2Completed = value!;
                    if (value) {
                      motivationMessage =
                          "Music can calm the mind. You’re doing well!";
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text(
                    "Task 3: Write down 3 things you are grateful for."),
                value: task3Completed,
                onChanged: (value) {
                  setState(() {
                    task3Completed = value!;
                    if (value) {
                      motivationMessage =
                          "Gratitude is a great way to uplift your spirit!";
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Task 4: Take a 10-minute walk outside."),
                value: task4Completed,
                onChanged: (value) {
                  setState(() {
                    task4Completed = value!;
                    if (value) {
                      motivationMessage = "A walk can help clear your mind!";
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Task 5: Call or message a friend."),
                value: task5Completed,
                onChanged: (value) {
                  setState(() {
                    task5Completed = value!;
                    if (value) {
                      motivationMessage =
                          "Talking to a friend can bring comfort!";
                    }
                  });
                },
              ),
              const SizedBox(height: 30),
              // Text field for gratitude
              const Text(
                "Take a moment to think about what you're grateful for:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _gratefulController,
                decoration: const InputDecoration(
                  labelText: "Gratitude List",
                  border: OutlineInputBorder(),
                  hintText: "Write down something you're grateful for",
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleGratitude,
                child: const Text('Submit Gratitude'),
              ),
              const SizedBox(height: 20),
              Text(
                motivationMessage,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _giveTaskAndAffirmation,
                child: const Text('Next Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSadReason() {
    setState(() {
      motivationMessage =
          "You're doing great! Let's work together to lift your mood.";
    });
  }

  void _handleGratitude() {
    setState(() {
      if (_gratefulController.text.isNotEmpty) {
        motivationMessage = "Gratitude is a powerful tool for happiness!";
      } else {
        motivationMessage = "Please write something you're grateful for.";
      }
    });
  }

  void _giveTaskAndAffirmation() {
    setState(() {
      motivationMessage = "You are strong, and you will overcome this!";
    });
    // You can add more tasks, motivation, and affirmation here.
  }
}
