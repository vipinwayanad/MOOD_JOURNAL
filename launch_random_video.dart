import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_project/Pages/youtube_service.dart'; // Ensure this import is present

Future<void> launchRandomVideo(String mood) async {
  final youTubeService = Serviceyoutube(); // Instantiate YouTubeService

  try {
    // Fetch video IDs based on mood
    List<String> videoIds = await youTubeService.fetchRandomVideos(mood);

    if (videoIds.isNotEmpty) {
      // Select a random video ID
      String randomVideoId =
          videoIds[0]; // You can use Random() to select a different one

      // Construct the video URL
      final String videoUrl = 'https://www.youtube.com/watch?v=$randomVideoId';

      // Attempt to launch the video URL
      final Uri uri = Uri.parse(videoUrl);
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch $videoUrl';
      }
    } else {
      throw 'No videos found for mood: $mood';
    }
  } catch (e) {
    print('Error fetching or launching video: $e');
  }
}
