import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';
import 'package:flutter_gismo/infra/ui/bluetooth.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/services/BluetoothService.dart';




class BluetoothPresenter {

  final BluetoothContract _view;
  final BluetoothGismoService _service = BluetoothGismoService();

  BluetoothPresenter(this._view) {
    _service.init(onConnectionStateChanged, null);
  }

   onConnectionStateChanged(BluetoothConnectionState state) {
    debug.log("state $state.status", name: "BluetoothPresenter::onConnectionStateChanged");
    this._view.bluetoothState = state;
   }

  /*
  void handlerStatus(StatusBlueTooth event) {
    if (event.connectionStatus == null);
      //event.connectionStatus =  BluetoothManager.NONE;
     if (_view.bluetoothState.connectionStatus != event.connectionStatus) {
       debug.log("Connection status " + event.connectionStatus, name: "BluetoothPresenter::handlerStatus");
       _view.bluetoothState = event;
     }
   }*/

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
    //this._view.bluetoothState = await _service.startStatus(handlerStatus);
  }

  void connect(value) async {
    if (! value) {
      await _service.disconnect();
      // this._view.bluetoothState = StatusBlueTooth.none();
      // FIXME selectedDevice.connected = false;
      //_view.selectedDevice = selectedDevice;
      return;
    }
    bool status = await _service.connect(this._view.selectedDevice!.address);
    /*if (status) {
      this._view.bluetoothState = StatusBlueTooth.CONNECTED;
    }*/
  }

  void stopBluetoothStream()  {
    //this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    _view.selectedDevice = device;
  }

}