import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';

class BluetoothService {
  bool _streamStatus = false;
  final BluetoothManager _mgr = BluetoothManager();
  StreamSubscription<StatusBlueTooth> ? _bluetoothReadSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  Future<StatusBlueTooth> startStatus(Function f) async {
    StatusBlueTooth state = await this._mgr.getStatus();
    this._streamStatus = true;
    this.handleStatus(f);
    return state;
  }


  Future<StatusBlueTooth> connectBluetooth(String address) async {
     try {
       StatusBlueTooth state = await this._mgr.connectBlueTooth(address);
       this._streamStatus = true;
       return state;
    } on PlatformException catch(e) {
      debug.log("Erreur ", error: e );
    }
    return StatusBlueTooth.none();
  }

  Stream<StatusBlueTooth> _streamStatusBluetooth() async* {
    StatusBlueTooth  state;
    if ( ! _streamStatus)
      return;
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
    this._streamStatus = true;
    return await this._mgr.startReadBluetooth();
 }

  Stream<StatusBlueTooth> _streamReadBluetooth() async* {
    StatusBlueTooth  state;
    if ( ! _streamStatus)
      return;
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
    if (this._bluetoothReadSubscription != null)
      this._bluetoothReadSubscription!.cancel();
    this._streamStatus = false;
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