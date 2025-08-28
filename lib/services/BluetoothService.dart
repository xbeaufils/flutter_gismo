import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BluetoothService {
  bool _streamStatus = false;
  final BluetoothManager _mgr = BluetoothManager();
  StreamSubscription<StatusBlueTooth> ? _bluetoothReadSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  Future<String> startService() async{
    if (kIsWeb)
      return "start";
    try {
      //if ( await this._bloc.configIsBt()) {
      debug.log("Start service ", name: "BluetoothService::startService");
      StatusBlueTooth _bluetoothState =  await startReadBluetooth();
      if (_bluetoothState.connectionStatus != null)
        debug.log("Start status " + _bluetoothState.connectionStatus!, name: "BluetoothService::startService");
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
    String start= "start";// await PLATFORM_CHANNEL.invokeMethod("start");
    //setState(() {
      //_rfidPresent =  (start == "start");
    //});
    return start;
  }

  Future<BluetoothState> connectBluetooth(String address, Function f) async {
     try {
       BluetoothState state = await this._mgr.connectBlueTooth(address);
       return state;
    } on PlatformException catch(e) {
      debug.log("Erreur ", error: e );
    }
    return BluetoothState.none();
  }

  Stream<StatusBlueTooth> _streamStatusBluetooth() async* {
    StatusBlueTooth  state;
    /*if (_streamStatus)
      return;*/
    _streamStatus = true;
    while (_streamStatus) {
      await Future.delayed(Duration(milliseconds: 500));
      yield state = await _mgr.getStatus();
    }
  }

  void handleStatus(Function f) {
    _bluetoothStatusSubscription = this._streamStatusBluetooth().listen((StatusBlueTooth event) => f(event));
  }

  Future<StatusBlueTooth> startReadBluetooth() async {
    if (kIsWeb)
      return StatusBlueTooth.none();
    return await this._mgr.startReadBluetooth();
 }

  Stream<StatusBlueTooth> _streamReadBluetooth() async* {
    StatusBlueTooth  state;
    /*if (_streamStatus)
      return;*/
    _streamStatus = true;
    while (_streamStatus) {
      await Future.delayed(Duration(milliseconds: 500));
      yield state = await _mgr.readBluetooth();
    }
  }

  Future<StatusBlueTooth> readBluetooth() async {
    if (kIsWeb)
      return StatusBlueTooth.none();
    return await this._mgr.readBluetooth();
  }

  void handleData(Function f) {
    _bluetoothReadSubscription = this._streamReadBluetooth().listen((StatusBlueTooth event) => f(event));
  }

  void stopBluetooth() {
    this._mgr.stopBluetooth();
  }

  void stopReadBluetooth() {
    this._mgr.stopReadBluetooth();
  }

  void stopStream() {
    if (_bluetoothStatusSubscription != null)
      _bluetoothStatusSubscription!.cancel();
    _streamStatus = false;
  }

  Future<List<DeviceModel>> getDeviceList() async {
    return await _mgr.getDeviceList();
   }

}