import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
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
  // Singleton instance
  static final BluetoothGismoService _instance = BluetoothGismoService._internal();

  // Private constructor
  BluetoothGismoService._internal();

  // Factory constructor returns the same instance every time
  factory BluetoothGismoService() => _instance;
  StreamSubscription<dynamic>? _dataSub;
  StreamSubscription<BtcConnectionState>? _stateSub;

  final FlutterClassicBluetooth _bluetooth = FlutterClassicBluetooth();
  BtcConnectionState _connectionState = BtcConnectionState.disconnected;

  BtcConnectionState get connectionState => _connectionState;

  set connectionState(BtcConnectionState value) {
    _connectionState = value;
  }

  BtcConnection ? _connection;
  DeviceModel? _connectedDevice;
  DeviceModel ? get connectedDevice  => _connectedDevice;

  set connectedDevice(DeviceModel ? value) {
    _connectedDevice = value;
  }

   String _receivedData = '';

  void init (Function onConnectionStateChanged , Function onConnectionError, Function onDataReceived) {
    // Listen for Bluetooth state changes
    if (_connection == null)
      return;
    this._stateSub = _connection!.stateStream.listen(
      (BtcConnectionState state) {
        debug.log("State " + state.toString(), name: "BluetoothGismoService.onStateChanged");
      },
      onError: (error) {
        debugPrint('Bluetooth state error: $error');
      },
    );

    // Listen for incoming data
    _dataSub = _connection!.input.listen(
      (Uint8List data) => onDataReceived(data),
      onError: (error) {
        debug.log('Data received error: $error');
      },
    );
  }

  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  Future<bool> connect(DeviceModel device, Function onConnectionStateChanged , Function onDataReceived) async {
    try {
      this._connection = await _bluetooth.connect( address:device.address, timeout: const Duration(seconds: 8),);
      if (this._connection!.isConnected)
        this._connectedDevice =  device;
      this._stateSub = _connection!.stateStream.listen(
            (BtcConnectionState state) {
          debug.log("State " + state.toString(), name: "BluetoothGismoService.onStateChanged");
        },
        onError: (error) {
          debugPrint('Bluetooth state error: $error');
        },
      );

      // Listen for incoming data
      _dataSub = _connection!.input.listen(
            (Uint8List data) => onDataReceived(data),
        onError: (error) {
          debug.log('Data received error: $error');
        },
      );

      return _connection!.isConnected;
     } on BtcTimeoutException catch (ex)  {
      debug.log(ex.message, name: "BluetoothGismoService::connect");
      Sentry.captureException(ex);
    } on BtcConnectionException catch (e) {
      // Refused, or the service UUID is not offered.
      Sentry.captureException(e);
      debug.log(e.message, name: "BluetoothGismoService::connect");
    }
    return false;
  }

  Future<bool> disconnect() async {
    await _connection!.finish();
    this._connectedDevice = null;
    return true;
  }

  void stopStream() {
    if (_stateSub != null)
      _stateSub!.cancel();
    if (_dataSub != null)
      _dataSub!.cancel();
    if (_bluetoothStatusSubscription != null)
      _bluetoothStatusSubscription!.cancel();
  }

  Future<List<DeviceModel>> getDeviceList() async {
    List<DeviceModel> lstReturnDevice = [];
    try {
      List<BtcDevice> devices = await _bluetooth.getPairedDevices();
      for (BtcDevice device in devices) {
        lstReturnDevice.add(DeviceModel.fromResult(device.toMap()));
      }

    } catch (e) {
      debugPrint('Error loading paired devices: $e');
    }
    return lstReturnDevice;

   }

}