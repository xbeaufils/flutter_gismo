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
    _service.init(onConnectionStateChanged, onConnectionError, null);
  }

   onConnectionStateChanged(BluetoothConnectionState state) {
    debug.log("state " + state.status + " " + state.isConnected.toString(), name: "BluetoothPresenter::onConnectionStateChanged");
    this._view.bluetoothState = state;
   }

   onConnectionError(error) {
    debug.log("error " + error.toString(), name: "BluetoothPresenter::onConnectionError");
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
      this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: this._view.selectedDevice!.address, status: "DISCONNECTING");
      await _service.disconnect();
      return;
    }
    this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: this._view.selectedDevice!.address, status: "CONNECTING");
    bool status = await _service.connect(this._view.selectedDevice!.address);
  }

  void stopBluetoothStream()  {
    //this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    if (this._service.connectedDevice != null) {
      if (this._service.connectedDevice!.address == device.address)
        this._view.bluetoothState = BluetoothConnectionState(isConnected: true, deviceAddress: device.address, status: "CONNECTED");
      else
        this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: device.address, status: "DISCONNECTED");
    }
    else
      this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: device.address, status: "DISCONNECTED");
    _view.selectedDevice = device;
  }

}