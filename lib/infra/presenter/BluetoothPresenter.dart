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
  final BluetoothService _service = BluetoothService();
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;
  late Stream<BluetoothState> _bluetoothStream;

  BluetoothPresenter(this._view) {
    this._service.handleStatus( this.handlerStatus);
  }

  void handlerStatus(StatusBlueTooth event) {
    if (event.connectionStatus == null)
      event.connectionStatus =  BluetoothManager.NONE;
   if (_view.bluetoothState != event.connectionStatus)
        _view.bluetoothState = event.connectionStatus!;
   }

  Future<List<DeviceModel>> getDeviceList() async {
    List<DeviceModel> lstReturnDevice = await _service.getDeviceList();
    DeviceModel ? selectedDevice;
    lstReturnDevice.forEach((device) {
      if (device.connected )
        selectedDevice = device;
    });
    return lstReturnDevice;
  }

  void connect(value) {
    DeviceModel selectedDevice =  this._view.selectedDevice! ;

    if (! value) {
      stopBluetoothStream();
      _service.stopBluetooth();
      selectedDevice.connected = false;
      _view.selectedDevice = selectedDevice;
      return;
    }
    _service.connectBluetooth(selectedDevice.address, handleState);
  }

  void handleState(bool value, BluetoothState event) {
    _view.bluetoothState = event.status!;
    if (event.status == BluetoothManager.STARTED) {
      debug.log("Change connected " + value.toString(),  name: "BluetoothPresenter::startBlueTooth");
      DeviceModel selectedDevice = _view.selectedDevice!;
      selectedDevice.connected = value;
      _view.selectedDevice = selectedDevice;
    }

  }

  void stopBluetoothStream()  {
    if (this._bluetoothSubscription != null)
      this._bluetoothSubscription?.cancel();
    if (this._bluetoothStatusSubscription != null) {
      this._bluetoothStatusSubscription!.cancel();
    }
    this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    _view.selectedDevice = device;
  }

}