import 'dart:convert';

import 'package:dolphin_link/model/groq_api_client.dart';
import 'package:dolphin_link/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomeView extends StatefulWidget {
   const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel homeViewModel = HomeViewModel();
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


/// Turn  key: value, key2: value2  (optionally wrapped in { })  into  {"key":"value",...}

  //use gemini
  Future<Map<String, dynamic>> isPhishingUrl(String url) async {
    // 1. Build the prompt text safely
    final promptBase = dotenv.env['PHISHING_PROMPT'] ?? '';
    final promptText  = '$promptBase\n$url';

    // 2. Call Gemini and grab the *text* part of the response
    try{
    final response   = await Gemini.instance.prompt(
      parts: [Part.text(promptText)],
    );

    final raw = response?.output ?? '';           // adjust if your version uses .content?.parts?.last?.text
    if (raw.isEmpty) throw const FormatException('Empty response from Gemini');

    final cleaned = raw
        .replaceAll(RegExp(r'^```json|^```|```$'), '')
        .trim();

    // 4. Parse JSON safely
    final decoded = jsonDecode(cleaned);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected JSON shape (expected a map)');
    }
    return decoded;
}on GeminiException catch(e){
  debugPrint("Exception: ${e}");
}
    // 3. Strip markdown fences ONLY at the start/end
    return {"Error": "no response"};
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(HomeViewModel.homeTitle),
        backgroundColor: const Color.fromRGBO(0, 168, 240, 100),
         titleTextStyle:const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
         body: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Form(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Image.asset(HomeViewModel.dolphinLinkLogo, 
                   width: 250,
                   height: 250,), 
                   const SizedBox(height: 10,),
                   TextFormField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),),
                         contentPadding: const EdgeInsets.all(5),
                         label: const Text(HomeViewModel.urlLabel), 
                     ),
                   ),
                   Container(
                     margin:const EdgeInsets.only(top: 20),
                     width: double.infinity,
                     child: MaterialButton(
                       padding: const EdgeInsets.all(10),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                       onPressed: () async {
                        //phishing: http://beta.kenaidanceta.com/postamok/d39a2/source
                        
                        
                        //lig: https://blog.hubspot.com/marketing/email-open-click-rate-benchmark
                        final response = await groqApiClient.chatCompletions("http://www.dmega.co.kr/dmega/data/qna/sec/page.php?email=ZmFpdGhAc2VtYW50aWMuaW5mbw==");
                        var body = response.body;

                        content = extractCharacteristics(body);
                        print(content['phishing']);
                        print(content['risk']);
                        print(content['reason']);
                        // print(body);
                        //print(result);
                        setState(() {});
                       }, 
                       color:const Color.fromRGBO(0, 168, 240, 100),
                       textColor: Colors.white,
                       child:const Text("Check", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                     ),
                   ),
                   
                  Visibility(
                    visible: true,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: double.maxFinite,
                    
                      child:   Column(
                        children:  [
                           Card(
                            child: ListTile(
                              leading: const Icon(Icons.security, color: Colors.green, size: 35,),
                              title: const Text("Is it secure", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),),
                              subtitle: Text(content['phishing'] == true ? "No": "Yes", style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.percent, color: Colors.green, size: 35,),
                              title: const Text("Risk percentage", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),),
                              subtitle: Text("${content['risk']*100}%", style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.question_mark, color: Colors.green, size: 35,),
                              title: const Text("Reason", style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),),
                              subtitle: Text(content['reason'], style: const TextStyle( fontSize: 20),),
                            ),
                          ),
                        ],
                      )
                    ),
                  )
                 ],
               )),
           ),
         ),
    );
  }
}