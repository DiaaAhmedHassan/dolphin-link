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
        title: const Text(HomeViewModel.homeTitle),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: homeViewModel.homeKey,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                HomeViewModel.dolphinLinkLogo,
                width: 250,
                height: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator:homeViewModel.isUrlValid,
                controller: homeViewModel.urlController,
                cursorColor: Colors.blue,
                
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                  labelStyle: const TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      homeViewModel.clearText();
                    });
                  }, icon: const Icon(Icons.close, color: Colors.blue,)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const BorderSide(color: Colors.blue)
                  ),
                  
                  contentPadding: const EdgeInsets.all(5),
                  label: const Text(HomeViewModel.urlLabel),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: MaterialButton(
                  disabledColor: Colors.blue[200],
                  
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: homeViewModel.isloading?null:
                   () async {
                    //phishing: http://beta.kenaidanceta.com/postamok/d39a2/source
                    //lig: https://blog.hubspot.com/marketing/email-open-click-rate-benchmark
                    if(homeViewModel.homeKey.currentState!.validate()){
                      setState(() {
                        homeViewModel.isloading = true;
                      });
                    await homeViewModel
                        .checkPress(homeViewModel.urlController.text);
                    setState(() {
                      homeViewModel.isloading = false;
                    });}
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: homeViewModel.isloading?const CircularProgressIndicator(color: Colors.white,): const Text(
                    "Check",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              Visibility(
                visible: homeViewModel.isVisible,
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: double.maxFinite,
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.security,
                              color: homeViewModel.isItPhishing
                                  ? Colors.red
                                  : Colors.green,
                              size: 35,
                            ),
                            title: const Text(
                              "Is it secure",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              homeViewModel.isItPhishing == true ? "No" : "Yes",
                              style: TextStyle(
                                  color: homeViewModel.isItPhishing
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.percent,
                              color: homeViewModel.isItPhishing
                                  ? Colors.red
                                  : Colors.green,
                              size: 35,
                            ),
                            title: const Text(
                              "Risk percentage",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${homeViewModel.percentage}%",
                              style: TextStyle(
                                  color: homeViewModel.isItPhishing
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.question_mark,
                              color: homeViewModel.isItPhishing
                                  ? Colors.red
                                  : Colors.green,
                              size: 35,
                            ),
                            title: const Text(
                              "Reason",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              homeViewModel.reason,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          )),
        ),
      ),
    );
  }


}
