import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:developer' as debug;

import 'package:permission_handler/permission_handler.dart';

class LocationBloc {
  static const  GPS_CHANNEL = const MethodChannel('nemesys.GPS');
  bool _streamStatus = false;

  void initLocation() async {
    var status = await this._checkPermission(); //.then ( (permission) {
    if (status == PermissionStatus.granted) {
      Future response = GPS_CHANNEL.invokeMethod("startLocation");
      debug.log('Permission granted', name: "LocationBloc::initLocation");
    } else if (status == PermissionStatus.denied) {
      debug.log(
          'Permission denied. Show a dialog and again ask for the permission', name: "LocationBloc::initLocation");
    } else if (status == PermissionStatus.permanentlyDenied) {
      debug.log('Take the user to the settings page.', name: "LocationBloc::initLocation");
      await openAppSettings();
    }
  }

  Future _checkPermission()  async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
    return status;
  }

  Stream<LocationResult> streamLocation() async* {
    if (_streamStatus)
      return;
    LatLng latLng;
    _streamStatus = true;
    while (_streamStatus) {
      try {
        String response = await GPS_CHANNEL.invokeMethod("getLocation");
        debug.log("Location " + response, name: "LocationBloc::streamLocation");
        Map<String, dynamic> location = jsonDecode(response);
        await Future.delayed(Duration(milliseconds: 500));
        yield  LocationResult(true,
            LatLng(double.parse(location['Latitude']), double.parse(location['Longitude'])));
      } on PlatformException catch (err) {
        if (err.code.contains("NoLocation") ){
          yield  LocationResult.empty();
        }
        else {
          throw err;
        }
      }
    }
  }

  void stopStream() {
    _streamStatus = false;
  }
}

class LocationResult {
  late bool result ;
  LatLng? location;

  LocationResult.empty() {
    this.result  = false;
  }

  LocationResult(this.result, this.location);
}