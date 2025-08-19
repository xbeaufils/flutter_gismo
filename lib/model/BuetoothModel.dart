import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothState {
  String ? _status;
  String ? _data;

  BluetoothState.none() {
    _status = "NONE";
  }

  BluetoothState.fromResult(result) {
    _status = result["status"];
    if (_status != 'NONE')
      _data = result["data"];
  }

  String ? get data => _data;

  set data(String ? value) {
    _data = value;
  }

  String ? get status => _status;

  set status(String ? value) {
    _status = value;
  }
}

enum BluetoothPermission {
  noBluetoothScanPermission,
  noBluetoothConnectPermission, // Permission denied forever
  bluetoothOkPermission, // 00
}

class BluetoothModel  extends ChangeNotifier {
  BluetoothPermission _permission = BluetoothPermission.noBluetoothScanPermission;

  BluetoothPermission get permission => _permission;

  set permission(BluetoothPermission value) {
    if (value != this._permission) {
      _permission = value;
      notifyListeners();
    }
  }

  Future<bool> checkBlueToothPermission() async {
    bool denied = await Permission.bluetoothConnect.isDenied;
    if (denied) {
      this.permission= BluetoothPermission.noBluetoothConnectPermission;
      return false;
    }
    denied = await Permission.bluetoothScan.isDenied;
    if (denied) {
      this.permission = BluetoothPermission.noBluetoothScanPermission;
      return false;
    }
    this.permission = BluetoothPermission.bluetoothOkPermission;
    return true;
  }

  Future<bool> requestBlueToothPermission() async {
    PermissionStatus result;
    result = await Permission.bluetoothScan.request();
    if (result.isDenied) {
      this.permission = BluetoothPermission.noBluetoothScanPermission;
      return false;
    }
    result = await Permission.bluetoothConnect.request();
    if (result.isDenied) {
      this.permission = BluetoothPermission.noBluetoothConnectPermission;
      return false;
    }
    this.permission = BluetoothPermission.bluetoothOkPermission;
    return true;
  }
}