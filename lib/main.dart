

import 'package:dolphin_link/view/home_view.dart';
import 'package:dolphin_link/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await HomeViewModel.getCurrentLang();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,  
      home: HomeView(),
    );
  }
}

