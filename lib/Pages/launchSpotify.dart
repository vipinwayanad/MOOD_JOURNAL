import 'package:url_launcher/url_launcher.dart';

void _launchSpotifyPlayer(String playlistUri) async {
  final url = Uri.parse(playlistUri);
  if (await canLaunch(url.toString())) {
    await launch(url.toString());
  } else {
    throw 'Could not launch $url';
  }
}
