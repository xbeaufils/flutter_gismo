import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

enum   BluetoothAdapter{
  STATE_OFF,
  STATE_TURNING_ON,
  STATE_ON,
  STATE_TURNING_OFF,
  CONNECTED,
  DISCONNECTED,
  CONNECTING,
  DISCONNECTING,
  ERROR,
  UNKNOWN;

  static BluetoothAdapter fromResult(int result) {
    switch (result) {
      case 0:
        return BluetoothAdapter.STATE_OFF;
      case 1:
        return BluetoothAdapter.STATE_TURNING_ON;
      case 2:
        return BluetoothAdapter.STATE_ON;
      case 3:
        return BluetoothAdapter.STATE_TURNING_OFF;
      case 4:
        return BluetoothAdapter.CONNECTED;
      case 5:
        return BluetoothAdapter.DISCONNECTED;
      case 6:
        return BluetoothAdapter.CONNECTING;
      case 7:
        return BluetoothAdapter.DISCONNECTING;
      case 8:
        return BluetoothAdapter.ERROR;
      default:
        return BluetoothAdapter.UNKNOWN;
    }
  }
  static BluetoothAdapter fromString(String result) {
    if ( result.startsWith("ERROR"))
      return BluetoothAdapter.ERROR;
    switch (result) {
      case  "OFF":
        return BluetoothAdapter.STATE_OFF;
      case "TURNING_ON":
        return BluetoothAdapter.STATE_TURNING_ON;
      case "ON":
        return BluetoothAdapter.STATE_ON;
      case "TURNING_OFF":
        return BluetoothAdapter.STATE_TURNING_OFF;
      case "CONNECTED":
        return BluetoothAdapter.CONNECTED;
      case "DISCONNECTED":
        return BluetoothAdapter.DISCONNECTED;
      case "CONNECTING":
        return BluetoothAdapter.CONNECTING;
      case "DISCONNECTING":
        return BluetoothAdapter.DISCONNECTING;
      case "ERROR":
        return BluetoothAdapter.ERROR;
      default:
        return BluetoothAdapter.UNKNOWN;
    }
  }

}

class BluetoothGismoService {
  bool _streamStatus = false;

  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();
  BluetoothConnectionState? _connectionState;
  List<BluetoothDevice> _pairedDevices = [];
  BluetoothDevice? _connectedDevice;

  BluetoothDevice ? get connectedDevice  => _connectedDevice;

  set connectedDevice(BluetoothDevice ? value) {
    _connectedDevice = value;
  }

  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  StreamSubscription<BluetoothData>? _dataSubscription;
  StreamSubscription<BluetoothState>? _stateSubscription;

  String _receivedData = '';

  void init (Function onConnectionStateChanged , Function onConnectionError,
      Function onDataReceived(BluetoothData)?) {
    // Listen for Bluetooth state changes
    this._stateSubscription = _bluetooth.onStateChanged.listen(
      (state) {
        debug.log("State " + state.isEnabled.toString() + " " + state.status, name: "_bluetooth.onStateChanged");
      },
      onError: (error) {
        debugPrint('Bluetooth state error: $error');
      },
    );
    // Listen for connection state changes
    _connectionSubscription = _bluetooth.onConnectionChanged.listen(
      (BluetoothConnectionState state) => onConnectionStateChanged(state),
      onError: (error) {
        debugPrint('Connection state error: $error');
        return BluetoothConnectionState(deviceAddress: "", isConnected: false, status: "ERROR");
      },
    );

    // Listen for incoming data
    _dataSubscription = _bluetooth.onDataReceived.listen(
      onDataReceived,
      onError: (error) {
        debugPrint('Data received error: $error');
      },
    );
  }

  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  Future<bool> connect(String address) async {
    try {
      bool status = await _bluetooth.connect(address);
      this._connectedDevice = _pairedDevices.firstWhere((device) => device.address == address);
      return status;
     } on BluetoothException catch (ex)  {
      debug.log(ex.message, name: "BluetoothGismoService::connect");
      Sentry.captureException(ex);
    }
    return false;
  }

  Future<bool> disconnect() async {
    bool status = await _bluetooth.disconnect();
    return status;
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