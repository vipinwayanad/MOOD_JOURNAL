import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        title: const Text('Keep Happy'),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "You're feeling Happy! Let's keep that energy going.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
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
                    motivationMessage =
                        "Thank you for sharing! Let's keep the happiness going!";
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
                onPressed: () {
                  setState(() {
                    isTaskCompleted = true;
                    taskMessage =
                        "Great job! You reflected on your accomplishments. Keep it up!";
                  });
                },
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
              onChanged: (value) {
                setState(() {
                  funAnswer = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Your answer",
                border: OutlineInputBorder(),
                hintText: "Share with us...",
              ),
            ),
            const SizedBox(height: 30),
            if (funAnswer.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questionAnswered = true;
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text("Activity ${index + 1}"),
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
