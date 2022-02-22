import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'dart:developer' as debug;

class BluetoothBloc {
  bool _streamStatus = false;
  static const  BLUETOOTH_CHANNEL = const MethodChannel('nemesys.rfid.bluetooth');
  static const  String CONNECTED = "CONNECTED";
  static const String NONE = "NONE";
  static const String STARTED = "STARTED";
  static const String CONNECTING = "CONNECTING";
  static const String LISTEN = "LISTEN";
  static const String ERROR = "ERROR";

  Stream<StatusBlueTooth> streamStatusBluetooth() async* {
    StatusBlueTooth state;
    if (_streamStatus)
      return;
    _streamStatus = true;
    while (_streamStatus) {
      String strStatus = await BLUETOOTH_CHANNEL.invokeMethod("stateBlueTooth");
      debug.log("status " + strStatus, name: "BluetoothBloc::streamStatusBluetooth");
      await Future.delayed(Duration(milliseconds: 500));
      yield state = StatusBlueTooth.fromResult(json.decode(strStatus));
    }
  }

  Stream <BluetoothState> streamReadBluetooth() async* {
    String status;
    BluetoothState state;
    if (_streamStatus)
      return;
    _streamStatus = true;
    while (_streamStatus) {
      status = await BLUETOOTH_CHANNEL.invokeMethod("dataBlueTooth");
      await Future.delayed(Duration(seconds: 1));
      debug.log("data status " + status, name: "BluetoothBloc::streamReadBluetooth");
      yield  state = BluetoothState.fromResult(json.decode(status));
    }
  }

  void stopStream() {
    _streamStatus = false;
  }
}