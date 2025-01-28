import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyAuthPage extends StatefulWidget {
  const SpotifyAuthPage({super.key});

  @override
  _SpotifyAuthPageState createState() => _SpotifyAuthPageState();
}

class _SpotifyAuthPageState extends State<SpotifyAuthPage> {
  final String clientId = "2fed2165f5de4973900d8d33d10000d3";
  final String clientSecret = "f030551d371748c1a33b7d2b03f44fb1";
  final String redirectUri = "musicapp://callback"; // Use your redirect URI

  String? accessToken;

  // Spotify Authentication Flow
  Future<void> authenticateSpotify() async {
    final String authUrl =
        'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=user-library-read playlist-read-private';

    final result = await FlutterWebAuth.authenticate(
        url: authUrl, callbackUrlScheme: "musicapp");

    final Uri uri = Uri.parse(result);
    final String? code = uri.queryParameters['code'];

    if (code != null) {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          accessToken = data['access_token'];
        });
      } else {
        throw Exception('Failed to get access token');
      }
    }
  }

  Future<void> fetchCalmingPlaylists() async {
    if (accessToken == null) return;

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/browse/categories/relaxation/playlists'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final playlists = data['playlists']['items'];
      List<String> calmingPlaylistNames = [];
      for (var playlist in playlists) {
        calmingPlaylistNames.add(playlist['name']);
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Calming Playlists"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: calmingPlaylistNames
                .map((playlistName) => Text(playlistName))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        ),
      );
    } else {
      throw Exception('Failed to fetch playlists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spotify Music Player")),
      body: Center(
        child: accessToken == null
            ? ElevatedButton(
                onPressed: authenticateSpotify,
                child: Text("Connect to Spotify"),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Connected to Spotify!"),
                  ElevatedButton(
                    onPressed: fetchCalmingPlaylists,
                    child: Text("Get Calming Playlists"),
                  ),
                ],
              ),
      ),
    );
  }
}
