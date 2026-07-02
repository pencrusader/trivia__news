import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/brief.dart';
import '../models/health.dart';

class GithubApi {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/pencrusader/trivia__news/main';

  final http.Client _client;

  GithubApi({http.Client? client}) : _client = client ?? http.Client();

  Future<Brief> fetchLatestBrief() async {
    final response = await _client.get(Uri.parse('$_baseUrl/latest.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load latest brief: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Brief.fromJson(json);
  }

  Future<Brief> fetchBriefByDate(String date) async {
    final response = await _client.get(Uri.parse('$_baseUrl/briefs/$date.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load brief for $date: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Brief.fromJson(json);
  }

  Future<PiHealth> fetchHealth() async {
    final response = await _client.get(Uri.parse('$_baseUrl/health.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load health data: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PiHealth.fromJson(json);
  }

  void dispose() {
    _client.close();
  }
}
