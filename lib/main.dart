

import 'package:dolphin_link/services/navigation_service/navigation_services.dart';
import 'package:dolphin_link/view/home_view.dart';
import 'package:dolphin_link/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await HomeViewModel.getCurrentLang();
  MobileAds.instance.initialize();
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,  
      navigatorKey: NavigationServices.navigatorKey,
      home:  HomeView(),
    );
  }
}

