import 'package:dolphin_link/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
   const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel homeViewModel = HomeViewModel();


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
                       onPressed: (){}, 
                       color:const Color.fromRGBO(0, 168, 240, 100),
                       textColor: Colors.white,
                       child:const Text("Check", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                     ),
                   ),

                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: double.maxFinite,
                    child:  ListView(
                      shrinkWrap: true,
                      children:const [
                           ListTile(
                            leading: Icon(Icons.access_alarm_sharp),
                            title: Text("Domain"),
                            subtitle: Text("reason"),
                            trailing: Icon(Icons.close, color: Colors.red,),
                         
                        ),
                          
                      ],
                    ),
                  )
                 ],
               )),
           ),
         ),
    );
  }
}