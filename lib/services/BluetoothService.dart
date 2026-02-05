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
      default:
        return BluetoothAdapter.UNKNOWN;
    }
  }
  static BluetoothAdapter fromString(String result) {
    switch (result) {
      case  "OFF":
        return BluetoothAdapter.STATE_OFF;
      case "TURNING_ON":
        return BluetoothAdapter.STATE_TURNING_ON;
      case "ON":
        return BluetoothAdapter.STATE_ON;
      case "TURNING_OFF":
        return BluetoothAdapter.STATE_TURNING_OFF;
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

  void init (Function onConnectionStateChanged ,
      Function onDataReceived(BluetoothData)?) {
    // Listen for Bluetooth state changes
    _stateSubscription = _bluetooth.onStateChanged.listen(
      (state) {
        debug.log("State " + state.isEnabled.toString() + " " + state.status);
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

  StreamSubscription<StatusBlueTooth> ? _bluetoothReadSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  Future<bool> connect(String address) async {
    try {
      bool status = await _bluetooth.connect(address);
      return status;
     } on BluetoothException catch (ex)  {
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