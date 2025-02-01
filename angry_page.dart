import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

class AngryPage extends StatefulWidget {
  const AngryPage({super.key});

  @override
  _AngryPageState createState() => _AngryPageState();
}

class _AngryPageState extends State<AngryPage> {
  // Emotion intensity tracking
  final Map<String, double> _emotionIntensity = {
    'Frustration': 0.0,
    'Anger': 0.0,
    'Stress': 0.0,
    'Anxiety': 0.0,
  };

  // Coping mechanisms
  final List<String> _copingMechanisms = [
    'Deep Breathing',
    'Meditation',
    'Physical Exercise',
    'Journaling',
    'Talking to a Friend',
  ];

  final List<String> _selectedCopingMechanisms = [];
  String? _randomAdvice;
  Timer? _meditationTimer;
  int _meditationSeconds = 0;

  @override
  void initState() {
    super.initState();
    _fetchRandomAdvice();
  }

  @override
  void dispose() {
    _meditationTimer?.cancel();
    super.dispose();
  }

  // Fetch random advice from API
  Future<void> _fetchRandomAdvice() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.adviceslip.com/advice'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _randomAdvice = data['slip']['advice'];
        });
      }
    } catch (e) {
      print('Error fetching advice: $e');
    }
  }

  // Fetch emotion history for graph
  Future<List<DocumentSnapshot>> _fetchEmotionHistory() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('emotional_tracking')
        .orderBy('timestamp', descending: true)
        .limit(7)
        .get();

    return querySnapshot.docs;
  }

  // Submit emotional state to Firestore
  void _submitEmotionalState() {
    Map<String, dynamic> emotionalData = {
      'emotions': _emotionIntensity
          .map((key, value) => MapEntry(key, value.toStringAsFixed(1))),
      'copingMechanisms': _selectedCopingMechanisms,
      'advice': _randomAdvice,
      'timestamp': FieldValue.serverTimestamp(),
    };

    FirebaseFirestore.instance
        .collection('emotional_tracking')
        .add(emotionalData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emotional state recorded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Delete emotional tracking entry
  void _deleteEmotionalEntry(String documentId) async {
    await FirebaseFirestore.instance
        .collection('emotional_tracking')
        .doc(documentId)
        .delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Entry deleted successfully')));
  }

  // Emotion trend graph
  // Replace the existing _buildEmotionTrendGraph() method with this:
  Widget _buildEmotionTrendGraph() {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _fetchEmotionHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        // Create bar groups for each emotion
        List<BarChartGroupData> barGroups =
            _emotionIntensity.keys.map((emotion) {
          return BarChartGroupData(
            x: _emotionIntensity.keys.toList().indexOf(emotion),
            barRods: [
              BarChartRodData(
                toY: snapshot.data!.map((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      return double.parse(data['emotions'][emotion] ?? '0.0');
                    }).reduce((a, b) => a + b) /
                    snapshot.data!.length,
                color: _getEmotionColor(emotion),
                width: 16,
              )
            ],
          );
        }).toList();

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            barGroups: barGroups,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _emotionIntensity.keys.toList()[value.toInt()],
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        );
      },
    );
  }

  // Meditation Timer Dialog
  void _startMeditationTimer() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Meditation Timer'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${_meditationSeconds ~/ 60}:${(_meditationSeconds % 60).toString().padLeft(2, '0')}'),
                ElevatedButton(
                  onPressed: () {
                    if (_meditationTimer == null ||
                        !_meditationTimer!.isActive) {
                      _meditationTimer =
                          Timer.periodic(Duration(seconds: 1), (timer) {
                        setState(() {
                          _meditationSeconds++;
                        });
                      });
                    }
                  },
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _meditationTimer?.cancel();
                  },
                  child: Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _meditationTimer?.cancel();
                    setState(() {
                      _meditationSeconds = 0;
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Breathing Exercise Dialog
  void _startBreathingExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Breathing Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('4-7-8 Breathing Technique'),
            Text('1. Inhale for 4 seconds'),
            Text('2. Hold breath for 7 seconds'),
            Text('3. Exhale for 8 seconds'),
            Text('Repeat 4 times'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Emotional history list
  Widget _buildEmotionalHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('emotional_tracking')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return Dismissible(
              key: Key(doc.id),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                _deleteEmotionalEntry(doc.id);
              },
              child: ListTile(
                title: Text('Emotional State'),
                subtitle: Text('Recorded on: ${doc['timestamp']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteEmotionalEntry(doc.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Emotion color mapping
  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Frustration':
        return Colors.red;
      case 'Anger':
        return Colors.redAccent;
      case 'Stress':
        return Colors.orange;
      case 'Anxiety':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Emotional Wellness',
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
              background: Image.network(
                'https://images.unsplash.com/photo-1579541671963-4b2ece8c2cfc',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Emotion Intensity Section
                _buildSectionTitle('Emotion Intensity'),
                ..._emotionIntensity.keys
                    .map((emotion) => _buildEmotionSlider(emotion)),

                SizedBox(height: 20),

                // Coping Mechanisms Section
                _buildSectionTitle('Coping Mechanisms'),
                Wrap(
                  spacing: 8.0,
                  children: _copingMechanisms
                      .map((mechanism) => ChoiceChip(
                            label: Text(mechanism),
                            selected:
                                _selectedCopingMechanisms.contains(mechanism),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedCopingMechanisms.add(mechanism);
                                } else {
                                  _selectedCopingMechanisms.remove(mechanism);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),

                SizedBox(height: 20),

                // Emotion Trend Graph
                _buildSectionTitle('Emotion Trend'),
                SizedBox(
                  height: 200,
                  child: _buildEmotionTrendGraph(),
                ),

                // Additional Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _startMeditationTimer,
                      child: Text('Meditation Timer'),
                    ),
                    ElevatedButton(
                      onPressed: _startBreathingExercise,
                      child: Text('Breathing Exercise'),
                    ),
                  ],
                ),

                // Random Advice Section
                _buildSectionTitle('Daily Advice'),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _randomAdvice ?? 'Fetching advice...',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Emotional History
                _buildSectionTitle('Emotional History'),
                _buildEmotionalHistory(),

                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitEmotionalState,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Record Emotional State',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  // Emotion intensity slider
  Widget _buildEmotionSlider(String emotion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emotion,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Slider(
          value: _emotionIntensity[emotion] ?? 0.0,
          min: 0.0,
          max: 10.0,
          divisions: 10,
          label: (_emotionIntensity[emotion] ?? 0.0).toStringAsFixed(1),
          activeColor: _getEmotionColor(emotion),
          inactiveColor: _getEmotionColor(emotion).withOpacity(0.3),
          onChanged: (double value) {
            setState(() {
              _emotionIntensity[emotion] = value;
            });
          },
        ),
      ],
    );
  }
}
