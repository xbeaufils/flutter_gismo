import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'dart:developer' as debug;

import 'package:sentry_flutter/sentry_flutter.dart';

class BluetoothManager {
  bool _streamStatus = false;
  static const  BLUETOOTH_CHANNEL = const MethodChannel('nemesys.rfid.bluetooth');
  static const  String CONNECTED = "CONNECTED";
  static const String NONE = "NONE";
  static const String STARTED = "STARTED";
  static const String CONNECTING = "CONNECTING";
  static const String LISTEN = "LISTEN";
  static const String ERROR = "ERROR";

  Future<StatusBlueTooth> startReadBluetooth() async {
    StatusBlueTooth state;
    //FlutterSecureStorage storage = new FlutterSecureStorage();
    //String address = await storage.read(key: "address");
    //debug.log("read data status " + address, name: "GismoBloc::startReadBluetooth");
    String status = await BLUETOOTH_CHANNEL.invokeMethod("readBlueTooth" ); //, { 'address': address});
    debug.log("read status " + status, name: "BluetoothManager::startReadBluetooth");
    state = StatusBlueTooth.fromResult(json.decode(status));
    return state;
  }
/*
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
*/
  Future<BluetoothState> connectBlueTooth(String address) async {
    String status = await BLUETOOTH_CHANNEL.invokeMethod("connectBlueTooth" , { 'address': address});
    return BluetoothState.fromResult(json.decode(status));
  }

  Stream<StatusBlueTooth> streamStatusBluetooth() async* {
    StatusBlueTooth state;
    if (_streamStatus)
      return;
    _streamStatus = true;
    while (_streamStatus) {
      String strStatus = await BLUETOOTH_CHANNEL.invokeMethod("stateBlueTooth");
      debug.log("status " + strStatus, name: "BluetoothManager::streamStatusBluetooth");
      await Future.delayed(Duration(milliseconds: 500));
      yield state = StatusBlueTooth.fromResult(json.decode(strStatus));
    }
  }

  Future<StatusBlueTooth> getStatus() async {
    StatusBlueTooth state;
    String strStatus = await BLUETOOTH_CHANNEL.invokeMethod("stateBlueTooth");
    debug.log("status " + strStatus, name: "BluetoothManager::streamStatusBluetooth");
    state = StatusBlueTooth.fromResult(json.decode(strStatus));
    return state;
  }

  Future<StatusBlueTooth> readBluetooth() async {
    String status;
    StatusBlueTooth state;
    status = await BLUETOOTH_CHANNEL.invokeMethod("dataBlueTooth");
    await Future.delayed(Duration(seconds: 1));
    debug.log("data status " + status, name: "BluetoothManager::readBluetooth");
    state = StatusBlueTooth.fromResult(json.decode(status));
    return state;
}

  void stopStream() {
    _streamStatus = false;
  }

  void stopReadBluetooth() {
    BLUETOOTH_CHANNEL.invokeMethod("stopReadBlueTooth");
  }

  void stopBluetooth() {
    BLUETOOTH_CHANNEL.invokeMethod("stopBlueTooth");
  }

  Future<List<DeviceModel>> getDeviceList() async {
    BluetoothModel model = new BluetoothModel();
    debug.log("Get device List ", name: "BluetoothManager::getDeviceList");
    String response = await BLUETOOTH_CHANNEL.invokeMethod("listBlueTooth");
    List<DeviceModel> lstReturnDevice = ( jsonDecode(response) as List).map( (i) => DeviceModel.fromResult(i)).toList();
    return lstReturnDevice;
  }

}