import 'package:dolphin_link/ads_service/ad_banner.dart';
import 'package:dolphin_link/localization.dart';
import 'package:dolphin_link/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel homeViewModel = HomeViewModel();
  final Localization localization = Localization();
  // final LangRepo langRepo = LangRepo();
  // String currentLang = LangRepo().currentLang;
  String currentLang = HomeViewModel.currentLang;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          currentLang == 'العربية' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization.langs[currentLang]['title']),
          backgroundColor: Colors.blue,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                icon: const Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                dropdownColor: Colors.white,
                isDense: true,
                value: currentLang, // Should be a String? (nullable)
                items: ['english', 'العربية']
                    .map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val ,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (val) async {
                  currentLang = val!;
                  await HomeViewModel.changeLang(val);
                  setState(() {
                    homeViewModel.onLanguageChanged();
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return ['english', 'العربية'].map((String val) {
                    return Text(
                      val,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18), // selected item = white
                    );
                  }).toList();
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              
                key: homeViewModel.homeKey,
                child: Container(
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
                        textDirection: TextDirection.ltr,
                        validator: homeViewModel.isUrlValid,
                        controller: homeViewModel.urlController,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelStyle: const TextStyle(color: Colors.blue),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  homeViewModel.clearText();
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.blue,
                              )),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue)),
                          contentPadding: const EdgeInsets.all(5),
                          label:
                              Text(localization.langs[currentLang]['enterUrl']),
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
                          onPressed: homeViewModel.isloading
                              ? null
                              : () async {
                                  if (!await homeViewModel
                                      .isConnectedToInternet()) {
                                    if (!context.mounted) return;
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                  localization.langs[currentLang]
                                                      ['noConnection']),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    HomeViewModel
                                                        .noConnectionPath,
                                                    width: 150,
                                                    height: 150,
                                                  ),
                                                  Text(localization
                                                          .langs[currentLang]
                                                      ['checkConnection'])
                                                ],
                                              ),
                                              actions: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(localization
                                                      .langs[currentLang]['ok']),
                                                )
                                              ],
                                            ));
                                    return;
                                  }
                                  //phishing: http://beta.kenaidanceta.com/postamok/d39a2/source
                                  //lig: https://blog.hubspot.com/marketing/email-open-click-rate-benchmark
                                  if (homeViewModel.homeKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      homeViewModel.isloading = true;
                                    });
                  
                                    try {
                                      if (!context.mounted) return;
                                      await homeViewModel.checkPress(context,
                                          homeViewModel.urlController.text);
                                    } on Exception catch (e) {
                                      debugPrint("$e");
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(localization
                                            .langs[currentLang]['timeout']),
                                        duration:
                                            const Duration(milliseconds: 500),
                                      ));
                                    }
                                    setState(() {
                                      homeViewModel.isloading = false;
                                    });
                                  }
                                },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: homeViewModel.isloading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  localization.langs[currentLang]['check'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                        ),
                      ),
                      Visibility(
                        visible: homeViewModel.isVisible,
                        child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                CustomCard(
                                  currentLang: currentLang, 
                                  label: localization.langs[currentLang]['isItSecure'], 
                                  text: homeViewModel.isItPhishing? localization.langs[currentLang]['no']: localization.langs[currentLang]['yes'], 
                                  icon: Icons.security,
                                  isItPhishing: homeViewModel.isItPhishing,),
                                CustomCard(
                                  currentLang: currentLang,
                                  label: localization.langs[currentLang]['riskPercentage'],
                                  text: '${homeViewModel.percentage}%',
                                  icon: Icons.percent,
                                  isItPhishing: homeViewModel.isItPhishing,),
                                CustomCard(
                                  currentLang: currentLang,
                                  label: localization.langs[currentLang]['reason'],
                                  text: homeViewModel.reason,
                                  icon: Icons.question_mark, 
                                  isItPhishing: homeViewModel.isItPhishing,),
                  
                                  
                              ],
                            )),
                      ),
                      const SizedBox(height: 10,),
                      const AdBannerWidget()
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
   CustomCard({
    super.key, 
    required this.currentLang, 
    required this.label,
    required this.text,
    required this.icon, required this.isItPhishing,
    });

  final HomeViewModel homeViewModel = HomeViewModel();
  final String currentLang;
  final String label;
  final String text;
  final IconData icon;
  final bool isItPhishing;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: isItPhishing ? Colors.red : Colors.green,
          size: 35,
        ),
        title: Text(
          label ,
          style: const TextStyle(
              fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
