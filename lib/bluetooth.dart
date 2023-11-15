import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/BluetoothBloc.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/DeviceModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

class BluetoothPermissionPage extends StatefulWidget {
  final GismoBloc _bloc;

  BluetoothPermissionPage(this._bloc,  {Key ? key}) : super(key: key);

  @override
  BluetoothPermissionPageState createState() => new BluetoothPermissionPageState(_bloc);

}
class BluetoothPermissionPageState extends State<BluetoothPermissionPage> {
  final GismoBloc _bloc;
  late final BluetoothModel _model;

  BluetoothPermissionPageState(this._bloc);

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
                  widget = new BluetoothPage(this._bloc);
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

  /*
  Widget viewDeviceList() {
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
                  onTap: () => this._selectDevice( device ),
                  selected:  (this._isDeviceSelected(device)),
                  selectedTileColor: Colors.lightGreen[100],
                ),
                ),
              ],)
              );
            },
          );
        },
        future: _getDeviceList()
    );

  }*/
}

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

  BluetoothBloc _btBloc = new BluetoothBloc();

  String _bluetoothState = BluetoothBloc.NONE;

  _BluetoothPagePageState(this._bloc);
  DeviceModel ? _selectedDevice;
  List<DeviceModel> ? _lstDevice;

  @override
  void initState()  {
  }

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
                    onTap: () => this._selectDevice( device ),
                    selected:  (this._isDeviceSelected(device)),
                    selectedTileColor: Colors.lightGreen[100],
                  ),
                ),
              ],)
              );
            },
          );
        },
        future: _getDeviceList()
    );
  }


  bool _isDeviceSelected(DeviceModel device) {
    if (this._selectedDevice == null)
      return false;
    return (this._selectedDevice!.address == device.address);
  }

  Widget _stateButton(DeviceModel device) {
    if ( this._isDeviceSelected(device)) {
      switch( this._bluetoothState) {
        case BluetoothBloc.NONE:
          return Switch(value: false, onChanged: (value) { _startBlueTooth(value);
              //_switchBluetooth(value, device.address);
          } );
        case BluetoothBloc.CONNECTING:
          return CircularProgressIndicator();
        case BluetoothBloc.LISTEN:
        case BluetoothBloc.CONNECTED :
          return Switch(value: true, onChanged: (value) { _startBlueTooth(value);
          //_switchBluetooth(value, device.address);
          } );
        case BluetoothBloc.ERROR:
          this._stopBluetoothStream();
           return Switch(value: false, onChanged: (value) { _startBlueTooth(value);
           //_switchBluetooth(value, device.address);
           } );

      }
    }
    return Container(width: 10,);
  }

  Future<List<DeviceModel>> _getDeviceList() async {
    BluetoothModel model = new BluetoothModel();
    //final bool permission = await model.requestBlueToothPermission();
    //if (permission)
    debug.log("Get device List ", name: "_getDeviceList");
    String response = await BLUETOOTH_CHANNEL.invokeMethod("listBlueTooth");
    this._lstDevice = ( jsonDecode(response) as List).map( (i) => DeviceModel.fromResult(i)).toList();
    List<DeviceModel> lstReturnDevice = this._lstDevice!;
    //this._preferredAddress = await this._bloc.configBt();
    this._lstDevice!.forEach((device) => {
      if (device.connected )
        this._selectedDevice = device
    });
    if (_selectedDevice != null)
      try {
        _bluetoothStatusSubscription = this._btBloc.streamStatusBluetooth().listen((event) {
          if (_bluetoothState  !=  event.connect) {
            _bluetoothState = event.connect;
            setState(() {
              if (event.connect == BluetoothBloc.CONNECTED) {
                this._selectedDevice!.connected = true;
                //this._bluetoothStatusSubscription!.cancel();
              }
            });
            if (this._bluetoothState == BluetoothBloc.ERROR )
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Erreur bluetooth"),));
          }
        });
      } on Exception catch (e, stackTrace) {
        Sentry.captureException(e, stackTrace : stackTrace);
        debug.log(e.toString());
      }
    return lstReturnDevice;
  }
/*
  void _switchBluetooth(bool on, String address) {
    this._startBlueTooth(on);
    if (on) {
      //_preferredAddress = address;
    }
    else {
      // TODO : Stop bluetooth

    }
  }
*/
  void _selectDevice(DeviceModel device) {
    setState(() {
      _selectedDevice = device;
    });
  }

  void _startBlueTooth(value) {
    if (! value) {
      this._stopBluetoothStream();
      this._bloc.stopBluetooth();
      setState(() {
        this._selectedDevice!.connected = false;
      });
      return;
    }
    try {
      this._bluetoothStream = this._bloc.streamConnectBluetooth(this._selectedDevice!.address);
      this._bluetoothSubscription = this._bluetoothStream.listen((BluetoothState event) {
        setState(() {
          _bluetoothState = event.status!;
          if (event.status == BluetoothBloc.STARTED) {
            debug.log("Change connected " + value.toString(),  name: "_startBlueTooth");
            this._selectedDevice!.connected = value;
          }
        });
      });
     } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    this._stopBluetoothStream();
  }

  void _stopBluetoothStream()  {
    if (this._bluetoothSubscription != null)
      this._bluetoothSubscription?.cancel();
    if (this._bluetoothStatusSubscription != null) {
      this._bluetoothStatusSubscription!.cancel();
      this._btBloc.stopStream();
    }
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
              style: Theme.of(context).textTheme.headline6,
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