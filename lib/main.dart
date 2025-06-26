
import 'package:dolphin_link/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  Gemini.init(apiKey: dotenv.env['AI_API_KEY']!);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeView(),
    );
  }
}

