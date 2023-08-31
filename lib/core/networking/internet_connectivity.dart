import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivity{
  static Future<bool> checkInternet() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    return (result == ConnectivityResult.mobile || result ==  ConnectivityResult.wifi) && await _checkConnection();
  }

  static Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}