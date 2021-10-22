import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:sentry/sentry.dart';

class BluetoothPage extends StatefulWidget {
  final GismoBloc _bloc;

  BluetoothPage(this._bloc,  {Key ? key}) : super(key: key);

  @override
  _BluetoothPagePageState createState() => new _BluetoothPagePageState(_bloc);
}

class _BluetoothPagePageState extends State<BluetoothPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;
  static const  BLUETOOTH_CHANNEL = const MethodChannel('nemesys.rfid.bluetooth');
  late Stream<BluetoothState> _bluetoothStream;
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;
  StreamSubscription<StatusBlueTooth> ? _bluetoothStatusSubscription;

  String _bluetoothState ="NONE";

  _BluetoothPagePageState(this._bloc);
  String ? _preferredAddress;
  bool _isBluetooth = false;
  bool _isConnected = false;
  DeviceModel ? _selectedDevice;
  List<DeviceModel> ? _lstDevice;

  @override
  void initState()  {/*
    this._bloc.configIsBt().then((isBluetooth) => {
      this._isBluetooth = isBluetooth,

      if (isBluetooth) {
        this._bloc.configBt().then((value) => { _changeAddress(value)})
      }

    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      key: _scaffoldKey,
      appBar: new AppBar(
          title: new Text('Connexion BlueTooth'),
        ),
      body:
      FutureBuilder(
        builder: (context, AsyncSnapshot deviceSnap) {
          if (deviceSnap.connectionState == ConnectionState.none &&
              deviceSnap.hasData == null) {
            return Container();
          }
          if (deviceSnap.data == null)
            return Container();
          return ListView.builder(
            itemCount: deviceSnap.data.length,
            itemBuilder: (context, index) {
              DeviceModel device = deviceSnap.data[index];
              //if (device.address == _preferredAddress )
              //  _selectedDevice=device;
              return Card( child:
              Row(children: [
                Flexible(child:
                  ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.address),
                    trailing: this._stateButton(device),
                    onTap: () => this._selectDevice( device ),
                    selected:  (this._isDeviceSelected(device)),
                    selectedTileColor: Colors.lightGreenAccent,
                  ),
                ),
              ],)
              );
            },
          );
        },
        future: _getDeviceList(),)
    );
  }
/*
  Widget _buildButton() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot deviceSnap) {
        if (deviceSnap.connectionState == ConnectionState.none &&
            deviceSnap.hasData == null) {
          return Container();
        }
        if (deviceSnap.data == null)
          return Container();
        if (_selectedDevice == null)
          return Container();
        if (_selectedDevice!.connected)
          return FloatingActionButton(
              child: Icon(Icons.bluetooth_disabled),
              backgroundColor: Colors.red,
              onPressed: () {_startBlueTooth(false); });
        return
          FloatingActionButton(
              child: Icon(Icons.bluetooth_connected),
              backgroundColor: Colors.green,
              onPressed: () {_startBlueTooth(true);}) ;
      },
      future: _getDeviceList()
    );
  }
 */

/*
  Widget _buildBody() {
    if (_isBluetooth)
    return FutureBuilder(
        builder: (context, AsyncSnapshot deviceSnap) {
          if (deviceSnap.connectionState == ConnectionState.none &&
              deviceSnap.hasData == null) {
            return Container();
          }
          if (deviceSnap.data == null)
            return Container();
          return ListView.builder(
            itemCount: deviceSnap.data.length,
            itemBuilder: (context, index) {
              DeviceModel device = deviceSnap.data[index];
              if (device.address == _preferredAddress )
                _selectedDevice=device;
              return Card( child:
                  Row(children: [
                    Flexible(child:
                    RadioListTile(
                      title: Text(device.name),
                      subtitle: Text(device.address),
                      value: device.address,
                      groupValue: _preferredAddress,
                      onChanged: (String ? value) {_changeAddress(value!);
                      })),
                  ],)
              );
            },
          );
        },
      future: _getDeviceList(),);
    else
      return Container();
  }
*/
  bool _isDeviceSelected(DeviceModel device) {
    if (this._selectedDevice == null)
      return false;
    return (this._selectedDevice!.address == device.address);
  }

  Widget _stateButton(DeviceModel device) {
    if ( this._isDeviceSelected(device)) {
      switch( this._bluetoothState) {
        case "NONE":
          return Switch(value: false, onChanged: (value) { _switchBluetooth(value, device.address); } );
        case "CONNECTING":
          return CircularProgressIndicator();
        case "LISTEN":
        case "CONNECTED" :
          return Switch(value: true, onChanged: (value) { _switchBluetooth(value, device.address); } );
      }
    }
    return Container(width: 10,);
  }

  Future<List<DeviceModel>> _getDeviceList() async {
    debug.log("Get device List ", name: "_getDeviceList");
    String response = await BLUETOOTH_CHANNEL.invokeMethod("listBlueTooth");
    this._lstDevice = ( jsonDecode(response) as List).map( (i) => DeviceModel.fromResult(i)).toList();
    List<DeviceModel> lstReturnDevice = this._lstDevice!;
    return lstReturnDevice;
  }

  void _switchBluetooth(bool on, String address) {
    this._startBlueTooth(on);
    if (on) {
      _preferredAddress = address;
    }
    else {
      // TODO : Stop bluetooth

    }
  }

  void _selectDevice(DeviceModel device) {
    setState(() {
      _selectedDevice = device;
    });
  }

  void _startBlueTooth(value) {
    /*
    if (this._selectedDevice != null)
      this._selectedDevice!.connected = value;
     */
    /*
    setState(() {
        this._isConnected = value;
    });
     */
    if (! value) {
      this._stopBluetoothStream();
      this._bloc.stopBluetooth();
      return;
    }

    try {
      this._bluetoothStream = this._bloc.streamConnectBluetooth(this._selectedDevice!.address);
      this._bluetoothSubscription = this._bluetoothStream.listen((BluetoothState event) {
        setState(() {
          _bluetoothState = event.status;
          if (event.status == 'STARTED') {
            debug.log("Change coonected " + value.toString(),  name: "_startBlueTooth");
            this._selectedDevice!.connected = value;
          }
        });
      });
      _bluetoothStatusSubscription = this._bloc.streamStatusBluetooth().listen((event) {
        debug.log("status " + event.toString(), name: "streamStatusBluetooth");
        if (event.connect == 'CONNECTED') {
          setState(() {
            this._selectedDevice!.connected = true;
          });
          this._bluetoothStatusSubscription!.cancel();
        }
      });
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }
/*
  void _switched(value) {
    this.setState(() {
      this._isBluetooth = value;
      this._bloc.saveBt(_isBluetooth, _preferredAddress);
    });
    if (this._isBluetooth == false) {
      _selectedDevice = null;
      this._bloc.stopBluetooth();
    }
  }
*/
  /*
  void _changeAddress(String value) {
    this._startBlueTooth(false);
    setState(() {
      _preferredAddress = value;
      if (this._lstDevice != null)
      for (DeviceModel device in this._lstDevice!) {
        if (device.address == value)
          this._selectedDevice = device;
      }
    });
    this._bloc.saveBt(_isBluetooth, _preferredAddress);
  }
*/
  @override
  void dispose() {
    super.dispose();
    this._stopBluetoothStream();
  }

  void _stopBluetoothStream()  {
    if (this._bluetoothSubscription != null)
      this._bluetoothSubscription?.cancel();
    if (this._bluetoothStatusSubscription != null)
      this._bluetoothStatusSubscription!.cancel();
   }
}