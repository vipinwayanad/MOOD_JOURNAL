import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HappyPage extends StatefulWidget {
  const HappyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HappyPageState createState() => _HappyPageState();
}

class _HappyPageState extends State<HappyPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _activityAnswerController =
      TextEditingController();
  String motivationMessage =
      "Keep the happiness flowing! What made you happy today?";
  String taskMessage =
      "Take a moment to reflect on your accomplishments today!";
  String funQuestion =
      "What's your favorite way to spread happiness to others?";
  String funAnswer = '';
  bool isTaskCompleted = false;
  bool questionAnswered = false;

  // Tracking user responses
  String? userHappyReason = '';
  bool? taskCompleted;

  // List of happiness-boosting activities
  final List<String> activities = [
    "Take a walk in the park.",
    "Listen to your favorite music.",
    "Write down three things you're grateful for.",
    "Watch a funny video.",
    "Call a friend or family member.",
    "Read an inspiring book or quote.",
    "Try a new hobby or craft.",
    "Practice mindfulness or meditate.",
    "Dance to your favorite song.",
    "Volunteer or help someone in need.",
    "Plan your next weekend getaway.",
    "Do a random act of kindness.",
    "Take a nap or rest.",
    "Go for a workout or yoga session.",
    "Treat yourself to a favorite snack.",
  ];

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  // Load saved responses from shared_preferences
  void _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userHappyReason = prefs.getString('happy_reason');
      taskCompleted = prefs.getBool('happy_task_completed') ?? false;
      questionAnswered = prefs.getBool('happy_question_answered') ?? false;
      funAnswer = prefs.getString('happy_fun_answer') ?? '';
    });
  }

  // Save answers to shared_preferences
  void _saveAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('happy_reason', _reasonController.text);
    prefs.setBool('happy_task_completed', isTaskCompleted);
    prefs.setBool('happy_question_answered', questionAnswered);
    prefs.setString('happy_fun_answer', funAnswer);
  }

  // Handle task completion
  void _completeTask() {
    setState(() {
      isTaskCompleted = true;
      taskMessage =
          "Great job! You reflected on your accomplishments. Keep it up!";
      _saveAnswers();
    });
  }

  // Handle answering the fun question
  void _answerFunQuestion(String answer) {
    setState(() {
      funAnswer = answer;
      questionAnswered = true;
      motivationMessage =
          "That's a wonderful way to spread joy! Keep that positivity flowing!";
      _saveAnswers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        title: const Text('Keep Happy'),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        // Wrap the entire body in a SingleChildScrollView
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align the content to the top
          children: [
            const Text(
              "You're feeling Happy! Let's keep that energy going.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            if (userHappyReason == null || userHappyReason!.isEmpty)
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "What made you happy today?",
                  border: OutlineInputBorder(),
                  hintText: "Share your happiness!",
                ),
                maxLines: 3,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_reasonController.text.isNotEmpty) {
                  setState(() {
                    userHappyReason = _reasonController.text;
                    motivationMessage =
                        "Thank you for sharing! Let's keep the happiness going!";
                    _saveAnswers();
                  });
                }
              },
              child: const Text('Submit Happiness'),
            ),
            const SizedBox(height: 20),
            Text(
              motivationMessage,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Text(
              taskMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (!isTaskCompleted)
              ElevatedButton(
                onPressed: _completeTask,
                child:
                    const Text('Complete Task: Reflect on Your Achievements'),
              ),
            const SizedBox(height: 30),
            Text(
              funQuestion,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: _answerFunQuestion,
              decoration: const InputDecoration(
                labelText: "Your answer",
                border: OutlineInputBorder(),
                hintText: "Share with us...",
              ),
            ),
            const SizedBox(height: 30),
            if (questionAnswered)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    motivationMessage =
                        "You're doing amazing! Keep spreading happiness!";
                  });
                },
                child: const Text('Next Step'),
              ),
            const SizedBox(height: 30),
            const Text(
              "Here are some activities to stay happy!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Displaying activities
            ListView.builder(
              shrinkWrap: true, // To prevent overflow and fit the content
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      activities[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
