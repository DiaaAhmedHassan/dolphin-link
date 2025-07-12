import 'package:dolphin_link/view/home_view.dart';
import 'package:dolphin_link/view_model/scanner_view_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});



  @override
  State<ScannerView> createState() => _ScannerViewState();


 
}

class _ScannerViewState extends State<ScannerView> {

   final ScannerViewModel scannerViewModel = ScannerViewModel();

   final GlobalKey qrKey = GlobalKey();
   Barcode? result;
   QRViewController? qrController;

   @override
  void initState() {
    super.initState();
    
    scannerViewModel.addListener((){
      setState(() {
});
    });
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SafeArea(child: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: QRView(key: scannerViewModel.qrKey, 
              onQRViewCreated: (QRViewController qrController){
                this.qrController = qrController;
                qrController.scannedDataStream.listen((scannedData){
                  setState(() {
                   result = scannedData;
                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> HomeView(url: result?.code,)),(route) => false,); 
                  });
                });
              }
              )),
          ],
        ),
      )),
    );
  }
}