import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';
import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BluetoothGismoService {
  bool _streamStatus = false;
  final BluetoothManager _mgr = BluetoothManager();

  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();
  BluetoothConnectionState? _connectionState;
  List<BluetoothDevice> _pairedDevices = [];
  BluetoothDevice? _connectedDevice;
  String _receivedData = '';

  void _listenToConnectionState() {
    _bluetooth.onConnectionChanged.listen((state) {
      debug.log("State " + state.isConnected.toString() + " " + state.deviceAddress +" " + state.status);

     _connectionState = state;
        if (state.isConnected) {
          // Find   the connected device
          _connectedDevice = _pairedDevices.firstWhere(
                (device) => device.address == state.deviceAddress,
            orElse: () => BluetoothDevice(
              name: 'Unknown Device',
              address: state.deviceAddress,
              paired: false,
            ),
          );
        } else {
          _connectedDevice = null;
        }
      });
  }

  void _listenToIncomingData() {
    _bluetooth.onDataReceived.listen((data) {
      debug.log("Data " + data.asString());
      _receivedData += '${data.asString()}\n';
    });
  }
  void _listenStateChanged() {
    _bluetooth.onStateChanged.listen((data) {
      debug.log("State " + data.isEnabled.toString() + " " + data.status);
    });
  }

  Future<void> _loadPairedDevices() async {
    try {
      List<BluetoothDevice> devices = await _bluetooth.getPairedDevices();
      _pairedDevices = devices;
    } catch (e) {
      debug.log('Error loading paired devices: $e');
    }
  }

  void init() {
    _loadPairedDevices();
    _listenToConnectionState();
    _listenStateChanged();
    _listenToIncomingData();
  }

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
      bool status = await _bluetooth.connect(address);
      if (status) {
        StatusBlueTooth btStatus = StatusBlueTooth.none();
        btStatus.connectionStatus = StatusBlueTooth.CONNECTED;
        return btStatus;
      }
      else
        return StatusBlueTooth.none();
    } on BluetoothException catch (ex)  {
      Sentry.captureException(ex);
    }
    return StatusBlueTooth.none();
  }

  Future<StatusBlueTooth> disconnect() async {
    bool status = await _bluetooth.disconnect();
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
    _bluetooth.onStateChanged.listen((state) => f(state));
    //_bluetoothStatusSubscription = this._streamStatusBluetooth().listen((StatusBlueTooth event) => f(event));
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
    _bluetooth.onDataReceived.listen((data) => f(data));
    // _bluetoothReadSubscription = this._streamReadBluetooth().listen((StatusBlueTooth event) => f(event));
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
    List<DeviceModel> lstReturnDevice = [];
    try {
      List<BluetoothDevice> devices = await _bluetooth.getPairedDevices();
      for (BluetoothDevice device in devices) {
        lstReturnDevice.add(DeviceModel.fromResult(device.toMap()));
      }

    } catch (e) {
      debugPrint('Error loading paired devices: $e');
    }
    return lstReturnDevice;

   }

}