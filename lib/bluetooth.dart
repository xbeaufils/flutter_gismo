import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';

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

  _BluetoothPagePageState(this._bloc);
  String ? _preferredAddress;
  bool _isBluetooth = false;
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
                  onChanged: (value) {switched(value);},
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
                RadioListTile(
                  title: Text(device.name),
                  subtitle: Text(device.address),
                  value: device.address,
                  groupValue: _preferredAddress,
                  onChanged: (String ? value) {_changeAddress(value!);
                  }),);
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

  void switched(value) {
    this.setState(() {
      this._isBluetooth = value;
      this._bloc.saveBt(_isBluetooth, _preferredAddress!);
    });
  }

  void _changeAddress(String value) {
    setState(() {
      _preferredAddress = value;
    });
    this._bloc.saveBt(_isBluetooth, _preferredAddress!);
  }

}