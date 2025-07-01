import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {

  late BannerAd _bannerAdd;
  bool _isAdLoaded = false;


  @override
  void initState() {
    super.initState();

    _bannerAdd = BannerAd(
      adUnitId: dotenv.env['ad_unit_key']!,
      request: const AdRequest(),
       size: AdSize.banner, 
       listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error){
          debugPrint("Ad failed to load");
          ad.dispose();
        }
       ),
    );

    _bannerAdd.load();
  }
  
  @override
  void dispose() {
    _bannerAdd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _isAdLoaded ? 
    SizedBox(
      width: _bannerAdd.size.width.toDouble(),
      height: _bannerAdd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAdd),
    ):
    const SizedBox(
      child: Text("No Ads at the current time"),
    )
    ;
  }
}