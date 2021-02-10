import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';

class BluetoothPage extends StatefulWidget {
  final GismoBloc _bloc;

  BluetoothPage(this._bloc,  {Key key}) : super(key: key);
  BluetoothPage.edit(this._bloc, {Key key}) : super(key: key);

  @override
  _BluetoothPagePageState createState() => new _BluetoothPagePageState(_bloc);
}

class _BluetoothPagePageState extends State<BluetoothPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;
  static const  BLUETOOTH_CHANNEL = const MethodChannel('nemesys.rfid.bluetooth');

  _BluetoothPagePageState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.lightGreen,
      key: _scaffoldKey,
      appBar: new AppBar(
          title: new Text('Traitement'),
        ),
      body:_buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          if (projectSnap.data == null)
            return Container();
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              DeviceModel device = projectSnap.data[index];
              return Column(
                children: <Widget>[
                  // Widget to display the list of project
                ],
              );
            },
          );
        },
      future: _getDeviceList(),);
  }

   Future<List<DeviceModel>> _getDeviceList() async {
    String response = await BLUETOOTH_CHANNEL.invokeMethod("listBlueTooth");
    List<DeviceModel> lstDevice =  jsonDecode(response);
    /*List<DeviceModel> tempList = new List();
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(new DeviceModel.fromResult(response.data[i]));
    }
    return tempList;*/
    return lstDevice;
  }
}