import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
class GroqApiClient {
  final String _apiKey;
  final String? _baseUrl = dotenv.env['API_BASE_URL'];

  GroqApiClient(this._apiKey);

  Future<http.Response> chatCompletions(String url) async{
    final prompt = dotenv.env['phishing_prompt'];
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json'
    };
    final body = {
      'model': 'llama-3.3-70b-versatile',
      'messages': [
        {'role': 'user', 'content': '$prompt$url'},
      ],
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: headers,
      body: jsonEncode(body)
    );

    return response;

  }
  
}