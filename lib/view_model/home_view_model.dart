import 'dart:convert';

import 'package:dolphin_link/model/groq_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeViewModel extends ChangeNotifier{
  static const String homeTitle = "Dolphin link";
  static const String dolphinLinkLogo = "images/dolphinlink.png";
  static const String urlLabel = "Enter URL here";

  TextEditingController urlController = TextEditingController();
  bool isVisible = false;
  bool isItPhishing = false;
  double percentage = 0.0;
  String reason = "";



  Map<String, dynamic> content = {};

  //use groq
  final groqApiClient = GroqApiClient(dotenv.env['AI_API_KEY']!);
  Map<String, dynamic> extractCharacteristics(String responseBody) {
    final decoded = jsonDecode(responseBody);
    final content = decoded['choices'][0]['message']['content'] as String;

    // Step 1: Clean the content string to make it valid JSON
    final fixedJson = content
        .replaceAll(RegExp(r'([,{])\s*(\w+)\s*:'), r'$1"\2":') // quote keys
        .replaceAll('True', 'true')
        .replaceAll('False', 'false')
        .replaceAll("'", '"') // convert single quotes to double quotes
        .trim();

    // Step 2: Parse it as a JSON Map
    final Map<String, dynamic> result = jsonDecode(fixedJson);
    return result;
  }

  checkPress(String url) async {
    final response = await groqApiClient.chatCompletions(url);
    var body = response.body;

    content = extractCharacteristics(body);
    isItPhishing = content['phishing'];
    percentage = content['risk']*100.0;
    reason = content['reason'];
    print(isItPhishing);
    print(percentage);
    print(reason);
    // print(body);
    //print(result);
    isVisible = true;
  }
}
