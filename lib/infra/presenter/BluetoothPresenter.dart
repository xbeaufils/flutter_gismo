import 'dart:async';

import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/infra/ui/bluetooth.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'dart:developer' as debug;


class BluetoothPresenter {

  final BluetoothContract _view;
  final BluetoothManager _mgr = BluetoothManager();
  final BluetoothService _service = BluetoothService();
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  late Stream<BluetoothState> _bluetoothStream;

  BluetoothPresenter(this._view);

  Future<List<DeviceModel>> getDeviceList() async {
    List<DeviceModel> lstReturnDevice = await _mgr.getDeviceList();
    DeviceModel ? selectedDevice;
    lstReturnDevice.forEach((device) {
      if (device.connected )
        selectedDevice = device;
    });
    if (selectedDevice != null) {
      try {
        _bluetoothStatusSubscription =
            this._mgr.streamStatusBluetooth().listen((event) {
              if (this._view.bluetoothState != event.connect) {
                this._view.bluetoothState = event.connect;
                if (event.connect == BluetoothManager.CONNECTED) {
                  selectedDevice!.connected = true;
                  //this._bluetoothStatusSubscription!.cancel();
                }
              }
              if (this._view.bluetoothState == BluetoothManager.ERROR)
                this._view.showMessage("Erreur bluetooth");
            });
      } on Exception catch (e, stackTrace) {
        Sentry.captureException(e, stackTrace: stackTrace);
        debug.log(e.toString());
      }
      this._view.selectedDevice = selectedDevice;
    }
    return lstReturnDevice;
  }

  void startBlueTooth(value) {
    DeviceModel selectedDevice =  this._view.selectedDevice! ;

    if (! value) {
      stopBluetoothStream();
      _service.stopBluetooth();
      selectedDevice.connected = false;
      _view.selectedDevice = selectedDevice;
      return;
    }
    try {
      _bluetoothStream = _service.streamConnectBluetooth(selectedDevice.address);
      _bluetoothSubscription = _bluetoothStream.listen((BluetoothState event) {
        _view.bluetoothState = event.status!;
        if (event.status == BluetoothManager.STARTED) {
          debug.log("Change connected " + value.toString(),  name: "_startBlueTooth");
          DeviceModel selectedDevice = _view.selectedDevice!;
          selectedDevice.connected = value;
          _view.selectedDevice = selectedDevice;
        }
      });
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

  void stopBluetoothStream()  {
    if (_bluetoothSubscription != null)
      _bluetoothSubscription?.cancel();
    if (_bluetoothStatusSubscription != null) {
      _bluetoothStatusSubscription!.cancel();
      _mgr.stopStream();
    }
  }

  void selectDevice (DeviceModel device) {
    _view.selectedDevice = device;
  }

}