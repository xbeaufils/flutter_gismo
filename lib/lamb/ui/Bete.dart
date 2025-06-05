import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/BluetoothBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/presenter/BetePresenter.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:intl/intl.dart';
import 'package:sentry/sentry.dart';


class BetePage extends StatefulWidget {
  Bete ? _bete;

  BetePage( this._bete, {Key ? key}) : super(key: key);

  @override
  _BetePageState createState() => new _BetePageState();
}

abstract class BeteContract extends GismoContract {
  Bete ? get bete;
  set bete(Bete ? value);
  void backWithBete();
}

class _BetePageState extends GismoStatePage<BetePage> implements BeteContract {
   DateTime _selectedDate = DateTime.now();
  //final df = new DateFormat('dd/MM/yyyy');
  late BetePresenter _presenter;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //BluetoothWidget btWidget;
  TextEditingController _dateEntreCtrl = new TextEditingController();
  TextEditingController _numBoucleCtrl = new TextEditingController();
  TextEditingController _numMarquageCtrl = new TextEditingController();
  String ? _nom;
  String ? _obs;
  Sex ? _sex ;
  String ? _motif;

  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');
  bool _rfidPresent = false;
  String _bluetoothState ="NONE";
  final BluetoothBloc _btBloc = new BluetoothBloc();
  late Stream<BluetoothState> _bluetoothStream;
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;

  _BetePageState();

  Widget _statusBluetoothBar() {
    if (! AuthService().subscribe)
      return Container();
    List<Widget> status = [];
    switch (_bluetoothState ) {
      case "NONE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text(S.of(context).not_connected));
        break;
      case "WAITING":
        status.add(Icon(Icons.bluetooth));
        status.add(Expanded( child: LinearProgressIndicator(),) );
        break;
      case "AVAILABLE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text(S.of(context).data_available));
    }
    return Row(children: status,);
  }

  @override
  Widget build(BuildContext context) {
    if (AuthService().subscribe)
      this._startService();
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(S.of(context).sheep),

        ),
        floatingActionButton: _buildRfid(),
        body: new Container(
          child: new Form(
            key: _formKey,
            child:
              SingleChildScrollView ( child:
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _statusBluetoothBar(),
                  new TextFormField(
                    controller: _numBoucleCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: S.of(context).identity_number, hintText: S.of(context).flock_number_hint),
                    validator: (value) {
                        if (value!.isEmpty) {
                          return S.of(context).identity_number_warn;
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
                      //keyboardType: TextInputType.number,
                    controller: _numMarquageCtrl,
                    decoration: InputDecoration(labelText: S.of(context).flock_number, hintText: S.of(context).flock_number_hint),
                    validator: (value) {
                        if (value!.isEmpty) {
                          return S.of(context).enter_flock_number;
                        }
                        return "";
                        },
                    onSaved: (value) {
                        setState(() {
                        _numMarquageCtrl.text = value!;
                        });
                      }
                  ),
                  new TextFormField(
                    //keyboardType: TextInputType.number,
                      initialValue: _nom,
                      decoration: InputDecoration(labelText: S.of(context).name, hintText: S.of(context).name_hint),
                      onSaved: (value) {
                        setState(() {
                          _nom = value;
                        });
                      }
                  ),
                  new Row(
                     children: <Widget>[
                      new Flexible (child:
                          RadioListTile<Sex>(
                            title: Text(S.of(context).male),
                            selected: _sex == Sex.male,
                            value: Sex.male,
                            groupValue: _sex,
                            onChanged: (Sex ? value) { setState(() { _sex = value; }); },
                          ),
                      ),
                      new Flexible( child:
                          RadioListTile<Sex>(
                            title: Text(S.of(context).female),
                            selected: _sex == Sex.femelle,
                            value: Sex.femelle,
                            groupValue: _sex,
                            onChanged: (Sex ? value) { setState(() { _sex = value; }); },
                          ),
                      ),]
                  ),
                  new TextFormField(
                    //keyboardType: TextInputType.number,
                      initialValue: _obs,
                      decoration: InputDecoration(
                          labelText: S.of(context).observations,
                          hintText: 'Obs',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder()),
                      maxLines: 3,
                      onSaved: (value) {
                        setState(() {
                          _obs = value;
                        });
                      }
                  ),
                  ElevatedButton (
                  // RaisedButton(
                      child: new Text(
                        (this.bete == null)? S.of(context).bt_add: S.of(context).bt_save,
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        try {
                          this._presenter.save(_numBoucleCtrl.text, _numMarquageCtrl.text, _sex, _nom, _obs, _dateEntreCtrl.text, _motif);
                        } on MissingNumBoucle {
                          super.showMessage(S.of(context).identity_number_warn);
                        } on MissingNumMarquage {
                          super.showMessage(S.of(context).flock_number_warn);
                        } on MissingSex {
                          super.showMessage(S.of(context).sex_warn);
                        } on ExistingBete {
                          super.showMessage(S.of(context).identity_number_error);
                        }
                      } ,
                      //color: Colors.lightGreen[700],
                  ),
              ]
    )),
    )));

  }

  Widget _buildRfid() {
    if (AuthService().subscribe && this._rfidPresent) {
      return FloatingActionButton(
          child: Icon(Icons.wifi),
          backgroundColor: Colors.green,
          onPressed: _readRFID);
    }
    else
      return Container();
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
        showMessage("Pas de boucle lue");
      }
    } on PlatformException catch (e) {
      showMessage("Pas de boucle lue");
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
  }

  @override
  void initState() {
    super.initState();
    this._presenter = BetePresenter(this);
    //this.btWidget = new BluetoothWidget(this.widget._bloc);
    if (this.bete == null )
      _dateEntreCtrl.text = DateFormat.yMd().format(_selectedDate);
    else {
      _dateEntreCtrl.text = DateFormat.yMd().format(this.bete!.dateEntree);
      _numBoucleCtrl.text = this.bete!.numBoucle;
      _numMarquageCtrl.text = this.bete!.numMarquage;
      _nom = this.bete!.nom;
      _sex = this.bete!.sex;
      _motif = this.bete!.motifEntree;
      _obs = this.bete!.observations;
    }
  }

  Future<String> _startService() async{
    try {
      //if ( await this._bloc.configIsBt()) {
        debug.log("Start service ", name: "_BetePageState::_startService");
        BluetoothState _bluetoothState =  await this._presenter.startReadBluetooth();
        if (_bluetoothState.status != null)
          debug.log("Start status " + _bluetoothState.status!, name: "_BetePageState::_startService");
        if (_bluetoothState.status == BluetoothBloc.CONNECTED
            || _bluetoothState.status == BluetoothBloc.STARTED) {
          this._bluetoothStream = this._btBloc.streamReadBluetooth();
          this._bluetoothSubscription = this._bluetoothStream.listen(
        //this.widget._bloc.streamBluetooth().listen(
                (BluetoothState event) {
                  if (this._bluetoothState != event.status)
                    setState(() {
                      this._bluetoothState = event.status!;
                      if (event.status == 'AVAILABLE') {
                        String ? _foundBoucle = event.data;
                        if ( _foundBoucle != null) {
                          if (_foundBoucle.length > 15)
                            _foundBoucle = _foundBoucle.substring(
                                _foundBoucle.length - 15);
                          _numBoucleCtrl.text =
                              _foundBoucle.substring(_foundBoucle.length - 5);
                          _numMarquageCtrl.text = _foundBoucle.substring(
                              0, _foundBoucle.length - 5);
                        }
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

  @override
  void dispose() {
    // other dispose methods
    _numBoucleCtrl.dispose();
    _numMarquageCtrl.dispose();
    this._presenter.stopReadBluetooth();
    this._btBloc.stopStream();
    if (this._bluetoothSubscription != null)
      this._bluetoothSubscription?.cancel();
    super.dispose();
  }

  void backWithBete() {
    Navigator.of(context).pop(this.bete);
  }

  @override
  Bete ? get bete => this.widget._bete;

   set bete(Bete ? value) {
     this.widget._bete = value;
   }

}