// lib/youtube_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Serviceyoutube {
  final String apiKey =
      'AIzaSyBm7q1ZxdL0gdydT9zemvtuw-t9WhR0GZI'; // Replace with your actual API key

  Future<List<String>> fetchRandomVideos(String mood) async {
    String searchQuery;

    // Set search query based on mood
    switch (mood) {
      case 'angry':
        searchQuery = 'anger management';
        break;
      case 'happy':
        searchQuery = 'motivational';
        break;
      case 'sad':
        searchQuery = 'uplifting';
        break;
      default:
        searchQuery = 'motivational';
    }

    // Construct the API URL
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$searchQuery&key=$apiKey&type=video&maxResults=5';

    // Make the API call
    final response = await http.get(Uri.parse(apiUrl));

    // Check for a successful response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> videoIds = [];

      // Extract video IDs from the response
      for (var item in data['items']) {
        if (item['id']['kind'] == 'youtube#video') {
          videoIds.add(item['id']['videoId']);
        }
      }
      return videoIds;
    } else {
      throw Exception('Failed to load videos: ${response.reasonPhrase}');
    }
  }
}
