import 'package:dolphin_link/services/navigation_service/navigation_services.dart';
import 'package:dolphin_link/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScannerViewModel extends ChangeNotifier{

  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? qrController;

  HomeViewModel? homeViewModel;


  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  onQrScanned(QRViewController qrController, HomeViewModel homeViewModel){
    this.qrController = qrController;
    debugPrint("---------------------------\nQr code scanned\n-----------------------------------------");
    qrController.scannedDataStream.listen((scannedData){
      result = scannedData;
      homeViewModel.urlController.text = '${result!.code}';
      NavigationServices.navigateTo("/");
      notifyListeners();
      
    });

  }
}