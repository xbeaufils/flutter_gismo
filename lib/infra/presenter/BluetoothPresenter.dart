import 'dart:async';

import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';
import 'package:flutter_gismo/infra/ui/bluetooth.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/services/BluetoothService.dart';




class BluetoothPresenter {

  final BluetoothContract _view;
  final BluetoothGismoService _service = BluetoothGismoService();

  BluetoothPresenter(this._view) {
     _service.init(onConnectionStateChanged, onConnectionError, onDataReceived);
  }

   void onConnectionStateChanged(BluetoothConnectionState state) {
    debug.log("state " + state.status + " " + state.isConnected.toString(), name: "BluetoothPresenter::onConnectionStateChanged");
    if (state.status.startsWith("ERR")) {
      state = BluetoothConnectionState(isConnected: false,
          deviceAddress: state.deviceAddress,
          status: "ERROR");
      this._service.connectedDevice = null;
    }
    this._view.bluetoothState = state;
   }

   void onConnectionError(error) {
    debug.log("error " + error.toString(), name: "BluetoothPresenter::onConnectionError");
   }

  void onDataReceived(BluetoothData data) {
    String received = data.asString();
    debug.log("received " + received, name: "BluetoothPresenter::onDataReceived");
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
      this._service.connectedDevice = null;
      await _service.disconnect();
      this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: this._view.selectedDevice!.address, status: "DISCONNECTED");
      return;
    }
    this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: this._view.selectedDevice!.address, status: "CONNECTING");
    bool status = await _service.connect(this._view.selectedDevice!);
    if (status) {
      this._service.connectedDevice = this._view.selectedDevice;
      this._service.connectedDevice!.connected = true;
    }
  }

  void stopBluetoothStream()  {
    //this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    if (this._service.connectedDevice != null) {
      if (this._service.connectedDevice!.address == device.address) {
        this._view.bluetoothState =
            BluetoothConnectionState(isConnected: true,
                deviceAddress: device.address,
                status: "CONNECTED");
      }
      else
        this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: device.address, status: "DISCONNECTED");
    }
    else
      this._view.bluetoothState = BluetoothConnectionState(isConnected: false, deviceAddress: device.address, status: "DISCONNECTED");
    _view.selectedDevice = device;
  }

}