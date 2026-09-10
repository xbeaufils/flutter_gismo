import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:flutter_gismo/infra/ui/bluetooth.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/services/BluetoothService.dart';




class BluetoothPresenter {

  final BluetoothContract _view;
  final BluetoothGismoService _service = BluetoothGismoService();

  BluetoothPresenter(this._view) {
    // _service.init(onConnectionStateChanged, onConnectionError, onDataReceived);
  }

   void onConnectionStateChanged(BtcConnectionState state) {
    debug.log("state " + state.name , name: "BluetoothPresenter::onConnectionStateChanged");
    this._view.state = state;
   }

   void onConnectionError(error) {
    debug.log("error " + error.toString(), name: "BluetoothPresenter::onConnectionError");
   }

  void onDataReceived(Uint8List data) {
    String received = data.toString();
    debug.log("received " + received, name: "BluetoothPresenter::onDataReceived");
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

  void connect(value) async {
    this._view.showSaving();
    if (! value) {
      this._view.state = BtcConnectionState.disconnecting;
      await _service.disconnect();
      return;
    }
    this._view.state = BtcConnectionState.connecting;
    bool status = await _service.connect(this._view.selectedDevice!, onConnectionStateChanged, onDataReceived);
    if (status) {
      this._service.connectedDevice = this._view.selectedDevice;
      this._service.connectedDevice!.connected = true;
    }
    this._view.hideSaving();
  }

  void stopBluetoothStream()  {
    this._service.stopStream();
    //this._service.stopStream();
  }

  void selectDevice (DeviceModel device) {
    if (this._service.connectedDevice != null) {
      if (this._service.connectedDevice!.address == device.address) {}
      else {}
    }
    else
    _view.selectedDevice = device;
  }

}