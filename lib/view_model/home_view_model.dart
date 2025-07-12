import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dolphin_link/localization.dart';
import 'package:dolphin_link/model/groq_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel{
  
  static const String dolphinLinkLogo = "images/dolphinlink.png";

  static const String logoPath = "images/dolphinlink.png";
  static const String noConnectionPath = "images/no_internet.png";
 



  TextEditingController urlController = TextEditingController();
  bool isVisible = false;
  bool isItPhishing = false;
  bool isloading = false;
  double percentage = 0.0;
  String reason = "";
  static String currentLang = 'english';

  static Map<String, String> supportedLanguage = {
    'english': 'english',
    'العربية': 'arabic'
  };
  GlobalKey<FormState> homeKey = GlobalKey();

  Localization localization = Localization();

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLang = prefs.getString('lang')??'english';
    bool appInArabic = currentLang == 'العربية';

    String translationPrompt = dotenv.env['translation_prompt']!;
    String sentText = !appInArabic?escapedUrl:'$translationPrompt ${supportedLanguage[currentLang]} ${dotenv.env['phishing_prompt']} $escapedUrl';
    debugPrint("Sent text: $sentText");
    final response = await groqApiClient.chatCompletions(sentText).timeout(const Duration(seconds: 15), 
    onTimeout: ()=>throw Exception("Time out: Server didn't respond in time. "));
    if(response.statusCode != 200){
      if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error happened while getting the response"), duration: Duration(milliseconds: 500),));}
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
      return localization.langs[currentLang]['noUrlProvided'];
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

static Future<void> changeLang(String val)async{
  // currentLang = val;

  currentLang = val;
  debugPrint('changed to: $currentLang');
  try{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('lang', val);
  getCurrentLang();
  }catch (e){
    debugPrint("Error saving the language");
  }
}

void onLanguageChanged(){
  isVisible = false;
  urlController.text = "";
}

static Future<void> getCurrentLang() async{
  
  try{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  debugPrint('app language: ${prefs.getString('lang')??'english'}');
  currentLang = prefs.getString('lang')??'english';
  debugPrint("the current language is: $currentLang");
  }catch(e){
    debugPrint("Error loading language");
  }
}



}
