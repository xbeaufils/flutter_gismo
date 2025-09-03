import 'dart:async';

import 'package:flutter_gismo/core/device/BluetoothMgr.dart';
import 'package:flutter_gismo/infra/ui/bluetooth.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';

import 'dart:developer' as debug;


class BluetoothPresenter {

  final BluetoothContract _view;
  final BluetoothService _service = BluetoothService();

  BluetoothPresenter(this._view) {
    this._service.handleStatus( this.handlerStatus);
  }

  void handlerStatus(StatusBlueTooth event) {
    if (event.connectionStatus == null)
      event.connectionStatus =  BluetoothManager.NONE;
     if (_view.bluetoothState.connectionStatus != event.connectionStatus) {
       debug.log("Connection status " + event.connectionStatus, name: "BluetoothPresenter::handlerStatus");
       _view.bluetoothState = event;
     }
   }

  Future<List<DeviceModel>> getDeviceList() async {
    List<DeviceModel> lstReturnDevice = await _service.getDeviceList();
    lstReturnDevice.forEach((device) {
      if (device.connected)
        if (this._view.selectedDevice == null) // Pas de device selectionné, on prend celui-ci
          this._view.selectedDevice = device;
        else if (this._view.selectedDevice!.name != device.name) // un device est sélectionné mais pas la même adresse
          this._view.selectedDevice = device;
    });
    return lstReturnDevice;
  }

  void startStatus() async {
    this._view.bluetoothState = await _service.startStatus(handlerStatus);
  }

  void connect(value) async {
    DeviceModel selectedDevice =  this._view.selectedDevice! ;

    if (! value) {
      _service.stopBluetooth();
      this._view.bluetoothState = StatusBlueTooth.none();
      selectedDevice.connected = false;
      _view.selectedDevice = selectedDevice;
      return;
    }
    StatusBlueTooth status = await _service.connectBluetooth(selectedDevice.address);
    this._view.bluetoothState = status;
  }

  void stopBluetoothStream()  {
    this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    _view.selectedDevice = device;
  }

}