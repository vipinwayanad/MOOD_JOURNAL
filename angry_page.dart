import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // Random Quote of the Day
  String _quoteOfTheDay = "";

  // Task completion state
  final Map<String, bool> _taskCompletionStatus = {
    'Take Deep Breaths': false,
    'Go for a Walk': false,
    'Write in a Journal': false,
    'Listen to Calming Music': false,
    'Practice Gratitude': false,
  };

  // Math Game State
  int _score = 0;
  int _bestScore = 0;
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  String _currentProblem = '';
  bool _isGameActive = false;
  Timer? _gameTimer;
  int _timerSeconds = 4;
  int _questionCount = 0;
  bool _isGameOver = false;
  List<int> _answerOptions = [];
  int? _selectedAnswer;
  int? _correctAnswer;

  // YouTube API State
  String _videoUrl = '';
  String? _youtubeApiKey;

  // Unsplash API State
  String _imageUrl = '';
  String? _unsplashApiKey;

  @override
  void initState() {
    super.initState();
    _youtubeApiKey = dotenv.env['YOUTUBE_API_KEY'];
    _unsplashApiKey = dotenv.env['UNSPLASH_API_KEY'];
    _fetchRandomQuote();
    _fetchRandomImage();
  }

  @override
  void dispose() {
    _meditationTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  // Fetch random quote from API // Ensure this import is present

  Future<void> _fetchRandomQuote() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.quotable.io/random'));

      // Debug: Print the status code and response body
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _quoteOfTheDay = data['content'];
        });
      } else {
        // Handle non-200 status codes
        print('Failed to fetch quote. Status Code: ${response.statusCode}');
        setState(() {
          _quoteOfTheDay = 'Failed to fetch quote. Please try again later.';
        });
      }
    } catch (e) {
      // Handle any exceptions
      print('Error fetching quote: $e');
      setState(() {
        _quoteOfTheDay = 'Error fetching quote. Please check your connection.';
      });
    }
  }

  // Fetch random image from Unsplash
  Future<void> _fetchRandomImage() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos/random?query=nature&client_id=$_unsplashApiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _imageUrl = data['urls']['regular'];
        });
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  // Meditation exercise
  void _startMeditationExercise() {
    setState(() {
      _meditationSeconds = 0;
    });

    _meditationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _meditationSeconds++;
      });
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Meditation Exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Meditate for 5 minutes.'),
            Text('Time: $_meditationSeconds seconds'),
            ElevatedButton(
              onPressed: () {
                _meditationTimer?.cancel();
                print("Meditation completed");
                Navigator.of(context).pop();
              },
              child: Text('Pause Meditation'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _meditationSeconds = 0;
                });
                _meditationTimer?.cancel();
                print("Meditation reset");
                Navigator.of(context).pop();
              },
              child: Text('Reset Meditation'),
            ),
          ],
        ),
      ),
    );
  }

  // Physical Exercise section
  void _completeExercise(String exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$exercise Exercise'),
        content: ElevatedButton(
          onPressed: () {
            print('$exercise completed');
            Navigator.of(context).pop();
          },
          child: Text('Completed'),
        ),
      ),
    );
  }

  // Generate a random math problem
  void _generateMathProblem() {
    final random = Random();
    final operators = ['+', '-', '*'];
    _operator = operators[random.nextInt(operators.length)];

    switch (_operator) {
      case '+':
        _num1 = random.nextInt(30) + 1; // 1-30
        _num2 = random.nextInt(30) + 1; // 1-30
        break;
      case '-':
        _num1 = random.nextInt(30) + 1; // 1-30
        _num2 = random.nextInt(_num1) + 1; // Ensure no negative results
        break;
      case '*':
        _num1 = random.nextInt(10) + 1; // 1-10
        _num2 = random.nextInt(10) + 1; // 1-10
        break;
    }

    // Calculate correct answer
    _correctAnswer = _calculateCorrectAnswer();

    // Generate random answer options
    _answerOptions = [_correctAnswer!];
    while (_answerOptions.length < 3) {
      int randomAnswer = _correctAnswer! + random.nextInt(10) - 5;
      if (randomAnswer != _correctAnswer &&
          !_answerOptions.contains(randomAnswer)) {
        _answerOptions.add(randomAnswer);
      }
    }
    _answerOptions.shuffle();

    setState(() {
      _currentProblem = '$_num1 $_operator $_num2 = ?';
      _timerSeconds = 4;
      _isGameActive = true;
      _isGameOver = false;
      _selectedAnswer = null;
    });

    _startGameTimer();
  }

  // Calculate correct answer
  int _calculateCorrectAnswer() {
    switch (_operator) {
      case '+':
        return _num1 + _num2;
      case '-':
        return _num1 - _num2;
      case '*':
        return _num1 * _num2;
      default:
        return 0;
    }
  }

  // Start the 4-second timer for the math game
  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isGameActive = false;
          _gameTimer?.cancel();
          _handleMissedQuestion();
        }
      });
    });
  }

  // Handle user's answer selection
  void _selectAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
    });

    if (answer == _correctAnswer) {
      _score++;
    } else {
      _score--;
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _questionCount++;
        if (_questionCount >= 10) {
          _endGame();
        } else {
          _generateMathProblem();
        }
      });
    });
  }

  // Handle missed questions (beyond 4 seconds)
  void _handleMissedQuestion() {
    setState(() {
      _score--;
      _questionCount++;
    });

    if (_questionCount >= 10) {
      _endGame();
    } else {
      _generateMathProblem();
    }
  }

  // End the game
  void _endGame() {
    setState(() {
      _isGameOver = true;
      _isGameActive = false;
      if (_score > _bestScore) {
        _bestScore = _score;
      }
    });
  }

  // Restart the game
  void _restartGame() {
    setState(() {
      _score = 0;
      _questionCount = 0;
      _isGameOver = false;
    });
    _generateMathProblem();
  }

  // Fetch a random YouTube video based on mood
  Future<void> _fetchAngryMoodVideo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=calming+music&type=video&key=$_youtubeApiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoId = data['items'][0]['id']['videoId'];
        setState(() {
          _videoUrl = 'https://www.youtube.com/watch?v=$videoId';
        });
      }
    } catch (e) {
      print('Error fetching YouTube video: $e');
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
              background: _imageUrl.isNotEmpty
                  ? Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                                  if (mechanism == 'Deep Breathing') {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Deep Breathing Exercise'),
                                        content: ElevatedButton(
                                          onPressed: () {
                                            print(
                                                "Breathing exercise completed");
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Completed'),
                                        ),
                                      ),
                                    );
                                  } else if (mechanism == 'Meditation') {
                                    _startMeditationExercise();
                                  } else if (mechanism == 'Physical Exercise') {
                                    _completeExercise('Physical');
                                  }
                                } else {
                                  _selectedCopingMechanisms.remove(mechanism);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),

                SizedBox(height: 20),

                // Random Quote of the Day
                _buildSectionTitle('Quote of the Day'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _quoteOfTheDay ?? 'Fetching quote...',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),

                // Tasks to Reduce Anger
                _buildSectionTitle('Tasks to Reduce Anger'),
                _buildTaskCard(
                  'Take Deep Breaths',
                  'Practice deep breathing for 5 minutes to calm your mind.',
                  _taskCompletionStatus['Take Deep Breaths']!,
                  () {
                    setState(() {
                      _taskCompletionStatus['Take Deep Breaths'] = true;
                    });
                  },
                ),
                _buildTaskCard(
                  'Go for a Walk',
                  'Take a 10-minute walk to clear your head and reduce stress.',
                  _taskCompletionStatus['Go for a Walk']!,
                  () {
                    setState(() {
                      _taskCompletionStatus['Go for a Walk'] = true;
                    });
                  },
                ),
                _buildTaskCard(
                  'Write in a Journal',
                  'Write down your thoughts and feelings to understand and manage your anger.',
                  _taskCompletionStatus['Write in a Journal']!,
                  () {
                    setState(() {
                      _taskCompletionStatus['Write in a Journal'] = true;
                    });
                  },
                ),
                _buildTaskCard(
                  'Listen to Calming Music',
                  'Listen to soothing music to help relax and reduce anger.',
                  _taskCompletionStatus['Listen to Calming Music']!,
                  () {
                    setState(() {
                      _taskCompletionStatus['Listen to Calming Music'] = true;
                    });
                  },
                ),
                _buildTaskCard(
                  'Practice Gratitude',
                  'List three things you are grateful for to shift your focus to positive thoughts.',
                  _taskCompletionStatus['Practice Gratitude']!,
                  () {
                    setState(() {
                      _taskCompletionStatus['Practice Gratitude'] = true;
                    });
                  },
                ),

                // Math Game Section
                _buildSectionTitle('Math Game to Distract and Focus'),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Best Score
                        Text(
                          'Best Score: $_bestScore',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Current Score
                        Text(
                          'Score: $_score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Game Over Message
                        if (_isGameOver)
                          Text(
                            'Game Over!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        SizedBox(height: 10),

                        // Current Problem
                        Text(
                          _currentProblem,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Timer
                        Text(
                          'Time Left: $_timerSeconds seconds',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                _timerSeconds <= 1 ? Colors.red : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Answer Options
                        Wrap(
                          spacing: 8.0,
                          children: _answerOptions.map((option) {
                            return ElevatedButton(
                              onPressed:
                                  _isGameActive && _selectedAnswer == null
                                      ? () => _selectAnswer(option)
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedAnswer != null
                                    ? (option == _correctAnswer
                                        ? Colors.green
                                        : (option == _selectedAnswer
                                            ? Colors.red
                                            : Colors.blue))
                                    : Colors.blue,
                              ),
                              child: Text('$option'),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),

                        // Game Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _isGameActive ? null : _restartGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: Text('Restart Game'),
                            ),
                            ElevatedButton(
                              onPressed: _isGameActive
                                  ? () {
                                      setState(() {
                                        _isGameActive = false;
                                        _gameTimer?.cancel();
                                      });
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: Text('Stop Game'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // YouTube Video Section
                _buildSectionTitle('Calming Video'),
                ElevatedButton(
                  onPressed: _fetchAngryMoodVideo,
                  child: Text('Watch Calming Video'),
                ),
                if (_videoUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Video URL: $_videoUrl'),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTaskCard(String title, String description, bool isCompleted,
      VoidCallback onComplete) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(description),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: isCompleted ? null : onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.green : Colors.blue,
              ),
              child: Text(isCompleted ? 'Completed' : 'Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }
}
