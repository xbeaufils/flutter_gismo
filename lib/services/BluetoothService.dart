import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/services.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';

class BluetoothService {
  static const  BLUETOOTH_CHANNEL = const MethodChannel('nemesys.rfid.bluetooth');

  Stream<BluetoothState> streamConnectBluetooth(String address) async* {
    BluetoothState state;
    /*FlutterSecureStorage storage = new FlutterSecureStorage();
    String address = await storage.read(key: "address");*/
    try {
      String status = await BLUETOOTH_CHANNEL.invokeMethod("connectBlueTooth", { 'address': address});
      debug.log("Connect status " + status, name: "streamConnectBluetooth");
      yield  state = BluetoothState.fromResult(json.decode(status));
    } on PlatformException catch(e) {
      debug.log("Erreur ", error: e );
    }
  }

  Future<BluetoothState> startReadBluetooth() async {
    BluetoothState state;
    //FlutterSecureStorage storage = new FlutterSecureStorage();
    //String address = await storage.read(key: "address");
    //debug.log("read data status " + address, name: "GismoBloc::startReadBluetooth");
    String status = await BLUETOOTH_CHANNEL.invokeMethod("readBlueTooth" ); //, { 'address': address});
    debug.log("read status " + status, name: "GismoBloc::startReadBluetooth");
    state = BluetoothState.fromResult(json.decode(status));
    return state;
  }

  void stopBluetooth() {
    BLUETOOTH_CHANNEL.invokeMethod("stopBlueTooth");
  }

  void stopReadBluetooth() {
    BLUETOOTH_CHANNEL.invokeMethod("stopReadBlueTooth");
  }

}