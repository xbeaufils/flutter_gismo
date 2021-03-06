import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/BluetoothWidget.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:intl/intl.dart';
import 'package:sentry/sentry.dart';


class BetePage extends StatefulWidget {
  final GismoBloc _bloc;
  Bete _bete;
  BetePage(this._bloc, this._bete, {Key key}) : super(key: key);

  @override
  _BetePageState createState() => new _BetePageState(_bloc, _bete);
}

class _BetePageState extends State<BetePage> {
  final GismoBloc _bloc;
  DateTime selectedDate = DateTime.now();
  final df = new DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BluetoothWidget btWidget;
  TextEditingController _dateEntreCtrl = new TextEditingController();
  TextEditingController _numBoucleCtrl = new TextEditingController();
  TextEditingController _numMarquageCtrl = new TextEditingController();
  Bete _bete;
  String _nom;
  String _obs;
  Sex _sex ;
  String _motif;

  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');
  bool _rfidPresent = false;
  String _bluetoothState ="NONE";
  _BetePageState(this._bloc, this._bete);

  Widget _statusBluetoothBar() {
    if (! this._bloc.isLogged())
      return Container();
    return FutureBuilder(
        future: this._bloc.configIsBt(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          if (! snapshot.data )
            return Container();
          List<Widget> status = new List();
          switch (_bluetoothState ) {
            case "NONE":
              status.add(Icon(Icons.bluetooth));
              status.add(Text("Non connecté"));
              break;
            case "WAITING":
              status.add(Icon(Icons.bluetooth));
              status.add(Expanded( child: LinearProgressIndicator(),) );
              break;
            case "AVAILABLE":
              status.add(Icon(Icons.bluetooth));
              status.add(Text("Données reçues"));
          }
          return Row(children: status,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Bete'),

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
                    decoration: InputDecoration(labelText: 'Numero boucle', hintText: 'Boucle'),
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Entrez un numero de boucle';
                        }
                        return "";
                      },
                      onSaved: (value) {
                          setState(() {
                            _numBoucleCtrl.text = value;
                        });
                      }
                  ),
                  new TextFormField(
                      //keyboardType: TextInputType.number,
                    controller: _numMarquageCtrl,
                    decoration: InputDecoration(labelText: 'Numero marquage', hintText: 'Marquage'),
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Entrez un numero de marquage';
                        }
                        return "";
                        },
                    onSaved: (value) {
                        setState(() {
                        _numMarquageCtrl.text = value;
                        });
                      }
                  ),
                  new TextFormField(
                    //keyboardType: TextInputType.number,
                      initialValue: _nom,
                      decoration: InputDecoration(labelText: 'Petit nom', hintText: 'Nom'),
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
                            title: const Text('Male'),
                            selected: _sex == Sex.male,
                            value: Sex.male,
                            groupValue: _sex,
                            onChanged: (Sex value) { setState(() { _sex = value; }); },
                          ),
                      ),
                      new Flexible( child:
                          RadioListTile<Sex>(
                            title: const Text('Femelle'),
                            selected: _sex == Sex.femelle,
                            value: Sex.femelle,
                            groupValue: _sex,
                            onChanged: (Sex value) { setState(() { _sex = value; }); },
                          ),
                      ),]
                  ),
                  new TextFormField(
                    //keyboardType: TextInputType.number,
                      initialValue: _obs,
                      decoration: InputDecoration(
                          labelText: 'Observations',
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
                  new RaisedButton(
                      child: new Text(
                        (_bete == null)?'Ajouter':'Enregistrer',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: _save,
                      color: Colors.lightGreen[700],
                  ),
              ]
    )),
    )));

  }

  Widget _buildRfid() {
    if (_bloc.isLogged() && this._rfidPresent) {
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
        _showMessage("Pas de boucle lue");
      }
    } on PlatformException catch (e) {
      _showMessage("Pas de boucle lue");
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
    }
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _save() async {
    _formKey.currentState.save();
    if (_numBoucleCtrl.text == null) {
      this.badSaving("Numéro de boucle absent");
      return;
    }
    if (_numBoucleCtrl.text.isEmpty){
      this.badSaving("Numéro de boucle absent");
      return;
    }
    if (_numMarquageCtrl.text == null){
      this.badSaving("Numéro de marquage absent");
      return;
    }
    if (_numMarquageCtrl.text.isEmpty){
      this.badSaving("Numéro de marquage absent");
      return;
    }
    if (_sex == null){
      this.badSaving("Sexe absent");
      return;
    }
    if (_bete == null)
      _bete = new Bete(null, _numBoucleCtrl.text, _numMarquageCtrl.text,_nom, _obs, _dateEntreCtrl.text, _sex, _motif);
    else {
      _bete.numBoucle = _numBoucleCtrl.text;
      _bete.numMarquage = _numMarquageCtrl.text;
      _bete.nom = _nom;
      _bete.observations = _obs;
      _bete.dateEntree =  _dateEntreCtrl.text;
      _bete.sex = _sex;
      _bete.motifEntree = _motif;
      _bloc.saveBete(_bete);
    }

    Navigator
        .of(context)
        .pop(_bete);
  }

  void goodSaving(String message) {
    Navigator.pop(context, message);
  }

  void badSaving(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);

  }

  @override
  void initState() {
    super.initState();
    //this.btWidget = new BluetoothWidget(this.widget._bloc);
    if (_bete == null )
      _dateEntreCtrl.text = df.format(selectedDate);
    else {
      _dateEntreCtrl.text = _bete.dateEntree;
      _numBoucleCtrl.text = _bete.numBoucle;
      _numMarquageCtrl.text = _bete.numMarquage;
      _nom = _bete.nom;
      _sex = _bete.sex;
      _motif = _bete.motifEntree;
      _obs = _bete.observations;
    }
    if (this._bloc.isLogged())
      this._startService();
  }

  Future<String> _startService() async{
    try {
      if ( await this._bloc.configIsBt()) {
        //this._bluetoothStream.listen((BluetoothState event) { })
        this.widget._bloc.streamBluetooth().listen(
                (BluetoothState event) {
                  if (_bluetoothState != event.status)
                    setState(() {
                      _bluetoothState = event.status;
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

  @override
  void dispose() {
    // other dispose methods
    _numBoucleCtrl.dispose();
    _numMarquageCtrl.dispose();
    this._bloc.stopBluetooth();
    super.dispose();
  }


}