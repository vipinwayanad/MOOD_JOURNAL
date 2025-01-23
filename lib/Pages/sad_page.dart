import 'package:flutter/material.dart';

class SadPage extends StatefulWidget {
  const SadPage({super.key});

  @override
  _SadPageState createState() => _SadPageState();
}

class _SadPageState extends State<SadPage> {
  final TextEditingController _reasonController = TextEditingController();
  String motivationMessage = "It's okay to feel sad. Let's uplift your spirit.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Overcome Sadness'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            ElevatedButton(
              onPressed: _giveTaskAndAffirmation,
              child: const Text('Next Task'),
            ),
          ],
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

  void _giveTaskAndAffirmation() {
    setState(() {
      motivationMessage = "You are strong, and you will overcome this!";
    });
    // You can add more tasks, motivation, and affirmation here.
  }
}
