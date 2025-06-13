import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/services.dart';
import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BluetoothService {
  static const  BLUETOOTH_CHANNEL =  MethodChannel('nemesys.rfid.bluetooth');
  final BluetoothManager _mgr = BluetoothManager();
  String _bluetoothState ="NONE";
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  Future<String> startService() async{
    try {
      //if ( await this._bloc.configIsBt()) {
      debug.log("Start service ", name: "_BetePageState::_startService");
      BluetoothState _bluetoothState =  await startReadBluetooth();
      if (_bluetoothState.status != null)
        debug.log("Start status " + _bluetoothState.status!, name: "_BetePageState::_startService");
      if (_bluetoothState.status == BluetoothManager.CONNECTED
          || _bluetoothState.status == BluetoothManager.STARTED) {
        this._bluetoothSubscription = this._mgr.streamReadBluetooth().listen(
          //this.widget._bloc.streamBluetooth().listen(
                (BluetoothState event) {
              if (this._bluetoothState != event.status)
                //setState(() {
                  this._bluetoothState = event.status!;
                  if (event.status == 'AVAILABLE') {
                    String ? _foundBoucle = event.data;
                    if ( _foundBoucle != null) {
                      if (_foundBoucle.length > 15)
                        _foundBoucle = _foundBoucle.substring(
                            _foundBoucle.length - 15);/*
                      _numBoucleCtrl.text =
                          _foundBoucle.substring(_foundBoucle.length - 5);
                      _numMarquageCtrl.text = _foundBoucle.substring(
                          0, _foundBoucle.length - 5);*/
                    }
                  }
                //});
            });
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
    String start= await PLATFORM_CHANNEL.invokeMethod("start");
    //setState(() {
      //_rfidPresent =  (start == "start");
    //});
    return start;
  }

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
  Stream <BluetoothState> streamReadBluetooth() {
    return _mgr.streamReadBluetooth();
  }
}