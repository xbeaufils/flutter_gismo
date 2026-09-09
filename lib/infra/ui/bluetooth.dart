import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/infra/presenter/BluetoothPresenter.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:provider/provider.dart';

class BluetoothPermissionPage extends StatefulWidget {

  BluetoothPermissionPage(  {Key ? key}) : super(key: key);

  @override
  BluetoothPermissionPageState createState() => new BluetoothPermissionPageState();
}

abstract class BluetoothPermissionContract extends GismoContract {

}

class BluetoothPermissionPageState extends State<BluetoothPermissionPage> {
  late final BluetoothModel _model;

  BluetoothPermissionPageState();

  @override
  void initState() {
    super.initState();

    _model = BluetoothModel();
    _model.checkBlueToothPermission();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _model,
        child: Consumer<BluetoothModel>(
            builder: (context, model, child) {
              Widget widget;
              switch (_model.permission) {
                case BluetoothPermission.noBluetoothConnectPermission:
                case BluetoothPermission.noBluetoothScanPermission :
                  widget = new BluetoothAskPermissions(onPressed: _checkPermissions,);
                  break;
                case BluetoothPermission.bluetoothOkPermission:
                  widget = new BluetoothPage();
              }
              return Scaffold(
                //backgroundColor: Colors.lightGreen,
                  appBar: new AppBar(
                    title: new Text('Connexion BlueTooth'),
                  ),
                  body:
                  widget);
            })
    );
  }

  Future<void> _checkPermissions() async {
    final hasFilePermission = await _model.requestBlueToothPermission();
  }

 }

class BluetoothPage extends StatefulWidget {


  BluetoothPage( {Key ? key}) : super(key: key);

  @override
  _BluetoothPagePageState createState() => new _BluetoothPagePageState();
}

abstract class BluetoothContract implements GismoContract {
  DeviceModel ? get selectedDevice;
  set selectedDevice(DeviceModel ? device);
 }

class _BluetoothPagePageState extends GismoStatePage<BluetoothPage> implements BluetoothContract {
  late BluetoothPresenter _presenter;
  final BluetoothGismoService _btService = BluetoothGismoService();

  _BluetoothPagePageState() {
    this._presenter = BluetoothPresenter(this);
    this._presenter.startStatus();
  }

  DeviceModel ? _selectedDevice;

  List<DeviceModel> ? _lstDevice;

  @override
  Widget build(BuildContext context) {
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
              return Card( child:
              Row(children: [
                Flexible(child:
                  ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.address),
                    trailing: this._stateButton(device),
                    onTap: () => this._presenter.selectDevice( device ),
                    selected:  (this._isDeviceSelected(device)),
                    selectedTileColor: Colors.lightGreen[100],
                  ),
                ),
              ],)
              );
            },
          );
        },
        future: this._presenter.getDeviceList()
    );
  }


  bool _isDeviceSelected(DeviceModel device) {
    if (this._selectedDevice == null)
      return false;
    return (this._selectedDevice!.address == device.address);
  }

  Widget _stateButton(DeviceModel device) {
    if ( this._isDeviceSelected(device)) {
      if (this._btService.connectionState == null)
        return Switch(value: false, onChanged: (value) { this._presenter.connect(value);});
      debug.log( "BluetoothState " + this._btService.connectionState.name, name: "_BluetoothPagePageState::_stateButton");
      switch(this._btService.connectionState) {
        case BtcConnectionState.disconnected:
          return Switch(value: false, onChanged: (value) { this._presenter.connect(value);});
        case BtcConnectionState.connected:
          return Switch(value: true, onChanged: (value) { this._presenter.connect(value);});
        case BtcConnectionState.connecting:
        case BtcConnectionState.disconnecting:
          return CircularProgressIndicator();
      }
    }
    return Container(width: 10,);
  }


  set selectedDevice(DeviceModel ? device) {
    setState(() {
      _selectedDevice = device;
    });
  }

   @override
  void dispose() {
    super.dispose();
    this._presenter.stopBluetoothStream();
  }

  DeviceModel ? get selectedDevice => _selectedDevice;

  List<DeviceModel> ? get lstDevice => _lstDevice;

  set lstDevice(List<DeviceModel> ? value) {
    _lstDevice = value;
  }
}

class BluetoothAskPermissions extends StatelessWidget {
  //final bool isPermanent;
  final VoidCallback onPressed;

  const BluetoothAskPermissions({
    Key? key,
    //required this.isPermanent,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
            ),
            child: Text(
              'Autorisation BlueTooth',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
            ),
            child: const Text(
              'L\'application a besoin de votre autorisation pour se connecter au lecteur de boucle.'
                  ,
              textAlign: TextAlign.center,
            ),
          ),
/*          if (isPermanent)
            Container(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 24.0,
                right: 16.0,
              ),
              child: const Text(
                'You need to give this permission from the system settings.',
                textAlign: TextAlign.center,
              ),
            ),
 */        Container(
            padding: const EdgeInsets.only(
                left: 16.0, top: 24.0, right: 16.0, bottom: 24.0),
            child: ElevatedButton(
              child: Text( 'Autoriser'),
              onPressed: () => onPressed(),
            ),
          ),
        ],
      ),
    );
  }
}