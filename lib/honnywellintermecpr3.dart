import 'dart:async';

import 'package:flutter/services.dart';

class Honnywellintermecpr3 {
  static const MethodChannel _channel = MethodChannel('honnywellintermecpr3');

  ///send device name and mac adress to native code
  ///String deviceName, bleutooth device name
  ///String deviceBleutoothMacAdress,bleutooth device name
  ///List cmd , commande to send to printer
  ///
  Future<dynamic> printGeneralWithExternalActivity(
      String deviceName, String deviceBleutoothMacAdress, List cmd) async {
    final String res = await _channel.invokeMethod('printGeneralWithActivity', {
      "deviceName": deviceName,
      "deviceBleutoothMacAdress": deviceBleutoothMacAdress,
      "cmd": cmd
    });
    return res;
  }

  Future<dynamic> printGeneral(
    String deviceName,
    String deviceBleutoothMacAdress,
    List cmd, {
    bool shouldDisconnect = true,
  }) async {
    final String res = await _channel.invokeMethod('printGeneral', {
      "deviceName": deviceName,
      "deviceBleutoothMacAdress": deviceBleutoothMacAdress,
      "cmd": cmd,
      "shouldDisconnect": shouldDisconnect,
    });
    return res;
  }

  Future<dynamic> printImage(
      String deviceName, String deviceBleutoothMacAdress, String base64) async {
    final String res = await _channel.invokeMethod('printImg', {
      "deviceName": deviceName,
      "deviceBleutoothMacAdress": deviceBleutoothMacAdress,
      "imageb64": base64,
    });
    return res;
  }
}
