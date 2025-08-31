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
     if (_view.bluetoothState != event.connectionStatus) {
       debug.log("Connection status " + event.connectionStatus, name: "BluetoothPresenter::handlerStatus");
       _view.bluetoothState = event;
     }
   }

  Future<List<DeviceModel>> getDeviceList() async {
    List<DeviceModel> lstReturnDevice = await _service.getDeviceList();
    DeviceModel ? selectedDevice;
    lstReturnDevice.forEach((device) {
      if (device.connected )
        this._view.selectedDevice = device;
    });
    return lstReturnDevice;
  }

  void connect(value) async {
    DeviceModel selectedDevice =  this._view.selectedDevice! ;

    if (! value) {
      stopBluetoothStream();
      _service.stopBluetooth();
      selectedDevice.connected = false;
      _view.selectedDevice = selectedDevice;
      return;
    }
    StatusBlueTooth status = await _service.connectBluetooth(selectedDevice.address, handlerStatus);
    this._view.bluetoothState = status;
  }

  void stopBluetoothStream()  {
    this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    _view.selectedDevice = device;
  }

}