import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dolphin_link/model/groq_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeViewModel extends ChangeNotifier{
  
  static const String homeTitle = "Dolphin link";
  static const String dolphinLinkLogo = "images/dolphinlink.png";
  static const String urlLabel = "Enter URL here";
  static const String checkButtonText = "check";
  static const String secureLabel = "Is it secure";
  static const String percentageLabel = "Risk percentage";
  static const String reasonLabel = "Reason";
  static const String yes = "Yes";
  static const String no = "No";
  static const String ok = "ok";
  static const String logoPath = "images/dolphinlink.png";
  static const String noConnectionPath = "images/no_internet.png";
  static const String noConnectionTitle = "No internet connection";
  static const String checkConnection = "Please check you'r internet connection";
  static const String timeoutText = "Timeout: Server didn't respond in time!";



  TextEditingController urlController = TextEditingController();
  bool isVisible = false;
  bool isItPhishing = false;
  bool isloading = false;
  double percentage = 0.0;
  String reason = "";

  GlobalKey<FormState> homeKey = GlobalKey();



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

  String escapeForPrompt(String url){
    return url.replaceAll('"', r'\"')
      .replaceAll('{', '')
      .replaceAll('}', '')
      .replaceAll('\n', ' ')
      .replaceAll('\r', '')
      .replaceAll('\$', r'\$')
      .replaceAll(" ", "/")
      .trim();
  }

  checkPress(BuildContext context, String url) async {
    String escapedUrl = escapeForPrompt(url);
    debugPrint(escapedUrl);
    final response = await groqApiClient.chatCompletions(escapedUrl).timeout(const Duration(seconds: 15), 
    onTimeout: ()=>throw Exception("Time out: Server didn't respond in time. "));
    if(response.statusCode != 200){
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error happened while getting the response"), duration: Duration(milliseconds: 500),));
    }
    var body = response.body;

    content = extractCharacteristics(body);
    isItPhishing = content['phishing'];
    percentage = content['risk']*100.0;
    reason = content['reason'];
    debugPrint('$isItPhishing');
    debugPrint('$percentage');
    debugPrint(reason);
    // print(body);
    //print(result);
    
    isVisible = true;
  }

  String? isUrlValid(val) {
    if (val == "") {
      return "No url provided";
    }
    return null;
  }

  void clearText(){
    urlController.text = "";
    isVisible = false;
  }
Future<bool> isConnectedToInternet()async{
  final results =await  Connectivity().checkConnectivity();
  return !results.contains(ConnectivityResult.none);
}
}
