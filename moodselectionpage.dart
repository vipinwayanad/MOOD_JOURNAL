import 'package:flutter/material.dart';
import 'package:flutter_project/Pages/angry_page.dart';
import 'package:flutter_project/Pages/happy_page.dart';
import 'package:flutter_project/Pages/profile_page.dart';
import 'package:flutter_project/Pages/sad_page.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';

class MoodSelectionPage extends StatefulWidget {
  const MoodSelectionPage({super.key});

  @override
  _MoodSelectionPageState createState() => _MoodSelectionPageState();
}

class _MoodSelectionPageState extends State<MoodSelectionPage> {
  // Mood data
  final List<MoodItem> _moods = [
    MoodItem(
      name: 'Happy',
      icon: 'assets/lottie/happy.json',
      color: Colors.yellow.shade700,
      page: HappyPage(),
    ),
    MoodItem(
      name: 'Sad',
      icon: 'assets/lottie/sad.json',
      color: Colors.blue.shade700,
      page: SadPage(),
    ),
    MoodItem(
      name: 'Angry',
      icon: 'assets/lottie/angry.json',
      color: Colors.red.shade700,
      page: AngryPage(),
    ),
    MoodItem(
      name: 'Calm',
      icon: 'assets/lottie/calm.json',
      color: Colors.green.shade700,
      page: HappyPage(),
    ),
  ];

  String userName = "User";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    // Implement user name fetching logic
    setState(() {
      userName = "Welcome, User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),

              // Mood Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _moods.length,
                  itemBuilder: (context, index) {
                    return _buildMoodCard(_moods[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display greeting
          Text(
            userName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(MoodItem mood) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          mood.color.withOpacity(0.4),
          mood.color.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mood.page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              mood.icon,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            Text(
              mood.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Add additional functionality like journaling or mood tracking
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      backgroundColor: Colors.white.withOpacity(0.3),
      child: Icon(Icons.person, color: Colors.white),
    );
  }
}

// Mood Item Model
class MoodItem {
  final String name;
  final String icon;
  final Color color;
  final Widget page;

  MoodItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.page,
  });
}
