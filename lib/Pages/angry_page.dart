import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class AngryPage extends StatefulWidget {
  const AngryPage({super.key});

  @override
  _AngryPageState createState() => _AngryPageState();
}

class _AngryPageState extends State<AngryPage> {
  final TextEditingController _reasonController = TextEditingController();
  double angerLevel = 100; // Start with the maximum anger level (100%)
  String motivationMessage = "Let's channel that anger into positive energy!";
  String taskMessage = "Take 5 deep breaths!";
  String funQuestion = "What helps you calm down when you're angry?";
  String funAnswer = '';
  bool isTaskCompleted = false;

  // Tracking user responses
  String? userAngerReason = '';
  bool? taskCompleted;
  bool? questionAnswered;

  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  // Timer variables
  int timerDuration = 5 * 60; // 5 minutes for deep breaths
  int remainingTime = 5 * 60; // Remaining time for countdown timer
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
    _startBackgroundMusic(); // Start soothing background music
  }

  // Load saved responses from shared_preferences
  Future<void> _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userAngerReason = prefs.getString('anger_reason');
      taskCompleted = prefs.getBool('anger_task_completed') ?? false;
      questionAnswered = prefs.getBool('anger_question_answered') ?? false;
      funAnswer = prefs.getString('anger_fun_answer') ?? '';
      angerLevel = prefs.getDouble('anger_level') ?? 100.0;
      remainingTime = prefs.getInt('anger_timer') ?? 5 * 60;
    });
  }

  // Save answers to shared_preferences
  Future<void> _saveAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('anger_reason', _reasonController.text);
    prefs.setBool('anger_task_completed', isTaskCompleted);
    prefs.setBool('anger_question_answered', questionAnswered ?? false);
    prefs.setString('anger_fun_answer', funAnswer);
    prefs.setDouble('anger_level', angerLevel);
    prefs.setInt('anger_timer', remainingTime);
  }

  // Start soothing background music
  void _startBackgroundMusic() async {
    if (!isPlaying) {
      await _audioPlayer.play(AssetSource('assets/soothing_sound.mp3'),
          volume: 0.5);
      setState(() {
        isPlaying = true;
      });
    }
  }

  // Stop the background music
  void _stopBackgroundMusic() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  // Handle task completion
  void _completeTask(String taskName) {
    setState(() {
      taskMessage = "$taskName task completed!";
      isTaskCompleted = true;
      // Reduce anger level based on the task completed
      angerLevel -= 10; // Each task reduces anger by 10
      _saveAnswers();
    });
  }

  // Timer countdown
  void _startTimer() {
    setState(() {
      remainingTime = timerDuration;
    });
    // Start a timer for deep breaths or other tasks
    Future.delayed(Duration(seconds: remainingTime), () {
      setState(() {
        taskMessage = "Time's up! Great job on completing the task!";
        isTaskCompleted = true;
        angerLevel -= 20; // Reduce anger level after timer is done
      });
    });
  }

  // Handle answering the fun question
  void _answerFunQuestion(String answer) {
    setState(() {
      funAnswer = answer;
      questionAnswered = true;
      motivationMessage =
          "Good choice! Now let's keep that positive energy going!";
      _saveAnswers();
    });
  }

  @override
  void dispose() {
    _stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        title: const Text('Anger Management'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You're feeling Angry! Let's work through it.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            if (userAngerReason == null || userAngerReason!.isEmpty)
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "What made you angry?",
                  border: OutlineInputBorder(),
                  hintText: "Write your reason here",
                ),
                maxLines: 3,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_reasonController.text.isNotEmpty) {
                  setState(() {
                    userAngerReason = _reasonController.text;
                    motivationMessage =
                        "Thank you for sharing! Let's work through this together.";
                    _saveAnswers();
                  });
                }
              },
              child: const Text('Submit Reason'),
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
                onPressed: () => _completeTask("Breathing Exercise"),
                child: const Text('Complete Task: Deep Breaths'),
              ),
            const SizedBox(height: 20),
            if (!isTaskCompleted)
              ElevatedButton(
                onPressed: _startTimer,
                child: const Text('Start Timer: 5-minute Breathing Exercise'),
              ),
            const SizedBox(height: 20),
            if (!isTaskCompleted)
              ElevatedButton(
                onPressed: () =>
                    _completeTask("Physical Activity (e.g., walk)"),
                child: const Text('Complete Task: Take a Walk'),
              ),
            const SizedBox(height: 20),
            if (!isTaskCompleted)
              ElevatedButton(
                onPressed: () => _completeTask("Mindfulness Meditation"),
                child: const Text('Complete Task: Meditation'),
              ),
            const SizedBox(height: 30),
            Text(
              "Anger Level: ${(angerLevel).toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: angerLevel,
              min: 0,
              max: 100,
              divisions: 10,
              label: "${angerLevel.toStringAsFixed(1)}%",
              onChanged: (value) {
                setState(() {
                  angerLevel = value;
                  _saveAnswers();
                });
              },
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
            if (questionAnswered ?? false)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    motivationMessage =
                        "You're doing great! Let's continue with the next step.";
                  });
                },
                child: const Text('Next Step'),
              ),
          ],
        ),
      ),
    );
  }
}
