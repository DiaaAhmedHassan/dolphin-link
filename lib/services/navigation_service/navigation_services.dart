import 'package:flutter/material.dart';

class NavigationServices {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  

  static Future<dynamic> navigateTo(String routeName){
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static void navigateBack(Object? argument){
    return navigatorKey.currentState!.pop(argument);
  }
}