import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
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

  String _bluetoothState ="NONE";

  _BluetoothPagePageState(this._bloc);
  String ? _preferredAddress;
  bool _isBluetooth = false;
  bool _isConnected = false;
  @override
  void initState()  {
    this._bloc.configIsBt().then((isBluetooth) => {
      this._isBluetooth = isBluetooth,
      if (isBluetooth) {
        this._bloc.configBt().then((value) => { _changeAddress(value)})
      }

    });
    //this._bloc.configBt().then((value) =>  { _changeAddress( value) });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.lightGreen,
      key: _scaffoldKey,
      appBar: new AppBar(
          title: new Text('Connexion BlueTooth'),
        ),
      body:
            Column(children: [
              Card( child:
              Row(children: <Widget>[
                Expanded(
                    child: Text("Lecteur Bluetooth")
                ),
                Switch(
                  value: _isBluetooth,
                  onChanged: (value) {_switched(value);},
                ),
              ])),
              Expanded(
                  child: _buildBody()
              ),
            ],)

    );
  }

  Widget _buildBody() {
    if (_isBluetooth)
    return FutureBuilder(
        builder: (context, AsyncSnapshot deviceSnap) {
          if (deviceSnap.connectionState == ConnectionState.none &&
              deviceSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          if (deviceSnap.data == null)
            return Container();
          return ListView.builder(
            itemCount: deviceSnap.data.length,
            itemBuilder: (context, index) {
              DeviceModel device = deviceSnap.data[index];
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
                    (device.address == _preferredAddress) ?
                    Switch(
                      value: this._isConnected,
                      onChanged: (value) {_startBlueTooth(value);},
                    ): Container(),
                  ],)
              );
            },
          );
        },
      future: _getDeviceList(),);
    else
      return Container();
  }

  Future<List<DeviceModel>> _getDeviceList() async {
    String response = await BLUETOOTH_CHANNEL.invokeMethod("listBlueTooth");
    List<DeviceModel> lstDevice = ( jsonDecode(response) as List).map( (i) => DeviceModel.fromResult(i)).toList();
    return lstDevice;
  }

  void _startBlueTooth(value) {
    this._isConnected = value;
    setState(() {
        this._isConnected = value;
    });
    if (! this._isConnected) {
      this._bloc.stopBluetooth();
      return;
    }
    try {
      this._bluetoothStream = this._bloc.streamConnectBluetooth();
      this._bluetoothSubscription = this._bluetoothStream.listen((BluetoothState event) {
         if (_bluetoothState != event.status)
              setState(() {
                _bluetoothState = event.status;
                if (event.status == 'AVAILABLE') {
                }
              });
      });
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

  void _switched(value) {
    this.setState(() {
      this._isBluetooth = value;
      this._bloc.saveBt(_isBluetooth, _preferredAddress);
    });
    if (this._isBluetooth == false) {
      this._bloc.stopBluetooth();
    }
  }

  void _changeAddress(String value) {
    setState(() {
      _preferredAddress = value;
    });
    this._bloc.saveBt(_isBluetooth, _preferredAddress);
  }

  @override
  void dispose() {
    super.dispose();
    if (this._bluetoothSubscription != null)
      this._bluetoothSubscription?.cancel();
  }

}