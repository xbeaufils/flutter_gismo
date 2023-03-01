import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/BluetoothBloc.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';
import 'package:sentry/sentry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BouclagePage extends StatefulWidget {
  LambModel _currentLamb ;
  final GismoBloc _bloc;
  //String _dateNaissance;
  BouclagePage( this._currentLamb, this._bloc, {Key ? key}) : super(key: key);

  @override
  _BouclagePageState createState() => new _BouclagePageState(this._bloc);
}

class _BouclagePageState extends State<BouclagePage> {
  final GismoBloc _bloc;
  final df = new DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');
  bool _rfidPresent = false;
  String _bluetoothState ="NONE";
  final BluetoothBloc _btBloc= new BluetoothBloc();


  //String _numBoucle;
  //String _numMarquage;
  TextEditingController _numBoucleCtrl = new TextEditingController();
  TextEditingController _numMarquageCtrl = new TextEditingController();

  _BouclagePageState(this._bloc);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(appLocalizations!.earring),
        ),
        floatingActionButton: _buildRfid(),
        body: new Container(
            child: new Form(
              key: _formKey,
              child:
              new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _statusBluetoothBar(),
                    new TextFormField(
                      controller: this._numBoucleCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Numero boucle', hintText: 'Boucle'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a name';
                          }
                          return "";
                        },
                        onSaved: (value) {
                          setState(() {
                            _numBoucleCtrl.text = value!;
                          });
                        }
                    ),
                    new TextFormField(
                        controller: this._numMarquageCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Numero marquage', hintText: 'Marquage'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a name';
                          }
                          return "";
                        },
                        onSaved: (value) {
                          setState(() {
                            _numMarquageCtrl.text = value!;
                          });
                        }
                    ),
                    new ElevatedButton(
                      child: new Text(
                        appLocalizations.place_earring,
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: _createBete,
                      //color: Colors.lightGreen[900],
                    ),
                  ]
              ),
            )));
  }

  @override
  void initState() {
    if (this._bloc.isLogged()!)
      this._startService();
  }

  Widget _buildRfid() {
    if (_bloc.isLogged()! && this._rfidPresent) {
      return FloatingActionButton(
          child: Icon(Icons.wifi),
          backgroundColor: Colors.green,
          onPressed: _readRFID);
    }
    else
      return Container();
  }

  Widget _statusBluetoothBar() {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    if (! this._bloc.isLogged()!)
      return Container();
    List<Widget> status = [];
    switch (_bluetoothState ) {
      case "NONE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text(appLocalizations!.not_connected));
        break;
      case "WAITING":
        status.add(Icon(Icons.bluetooth));
        status.add( Expanded( child: LinearProgressIndicator(),) );
        break;
      case "AVAILABLE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text(appLocalizations!.data_available));
    }
    return Row(children: status,);
  }

  void _readRFID() async {
    try {
      String response = await PLATFORM_CHANNEL.invokeMethod("startRead");
      await Future.delayed(Duration(seconds: 4));
      response = await PLATFORM_CHANNEL.invokeMethod("data");
      Map<String, dynamic> mpResponse = jsonDecode(response);
      if (mpResponse.length > 0) {
        setState(() {
          _numMarquageCtrl.text = mpResponse['marquage'];
          _numBoucleCtrl.text = mpResponse['boucle'];
        });
      }
      else {
        _showMessage("Pas de boucle lue");
      }
    } on PlatformException catch (e) {
      _showMessage("Pas de boucle lue");
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
  }

  @override
  void dispose() {
    _numBoucleCtrl.dispose();
    _numMarquageCtrl.dispose();
    this.widget._bloc.stopReadBluetooth();
    this._btBloc.stopStream();
    super.dispose();
  }

  void _createBete() async {
    _formKey.currentState!.save();
    this.widget._currentLamb.numMarquage = _numMarquageCtrl.text;
    this.widget._currentLamb.numBoucle = _numBoucleCtrl.text;
    Bete bete = new Bete(null, _numBoucleCtrl.text, _numMarquageCtrl.text, null, null, null, this.widget._currentLamb.sex, 'NAISSANCE');
    Navigator.pop(context, bete);
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void goodSaving(String message) {
    Navigator.pop(context, message);
  }

  void badSaving(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<String> _startService() async{
    try {
      debug.log("Start service ", name: "_BouclagePageState::_startService");
      BluetoothState _bluetoothState =  await this._bloc.startReadBluetooth();
      debug.log("Start status " + _bluetoothState.status, name: "_BouclagePageState::_startService");
      if (_bluetoothState.status == BluetoothBloc.CONNECTED
          || _bluetoothState.status == BluetoothBloc.STARTED) {
        //this._bluetoothStream.listen((BluetoothState event) { })
        this._btBloc.streamReadBluetooth().listen(
                (BluetoothState event) {
                  if (this._bluetoothState != event.status)
              setState(() {
                this._bluetoothState = event.status;
                if (event.status == 'AVAILABLE') {
                  String _foundBoucle = event.data;
                  if (_foundBoucle.length > 15)
                    _foundBoucle = _foundBoucle.substring(_foundBoucle.length - 15);
                  _numBoucleCtrl.text = _foundBoucle.substring(_foundBoucle.length - 5);
                  _numMarquageCtrl.text = _foundBoucle.substring(0, _foundBoucle.length - 5);
                }
              });
            });
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
    String start= await PLATFORM_CHANNEL.invokeMethod("start");
    setState(() {
      _rfidPresent =  (start == "start");
    });
    return start;
  }

}