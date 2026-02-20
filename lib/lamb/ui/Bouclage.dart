
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BoucleModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/lamb/presenter/LambPresenter.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:intl/intl.dart';


class BouclagePage extends StatefulWidget {
  LambModel _currentLamb ;
  BouclagePage( this._currentLamb, {Key ? key}) : super(key: key);

  @override
  _BouclagePageState createState() => new _BouclagePageState();
}

abstract class BouclageContract {
  void returnBete(Bete bete);
  StatusBlueTooth get  bluetoothState;
  set bluetoothState(StatusBlueTooth value);
  updateBoucle (BoucleModel numBoucle);
}

class _BouclagePageState extends State<BouclagePage> implements BouclageContract {
  final df = new DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late BouclagePresenter _presenter = BouclagePresenter(this);

  StatusBlueTooth _bluetoothState = StatusBlueTooth.none();

  StatusBlueTooth get bluetoothState => _bluetoothState;
  set bluetoothState(StatusBlueTooth value) {
    setState(() {
      _bluetoothState = value;
    });
  }

  TextEditingController _numBoucleCtrl = new TextEditingController();
  TextEditingController _numMarquageCtrl = new TextEditingController();

  _BouclagePageState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(S.of(context).earring),
        ),
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
                    Padding(padding:  const EdgeInsets.all(8.0),
                        child:
                          TextFormField(
                            controller: this._numBoucleCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: S.of(context).identity_number, hintText: S.of(context).identity_number_hint),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return S.of(context).enter_identity_number;
                                }
                                return "";
                              },
                              onSaved: (value) {
                                setState(() {
                                  _numBoucleCtrl.text = value!;
                                });
                              }
                          )),
                    Padding(padding:  const EdgeInsets.all(8.0),
                        child:
                          TextFormField(
                        controller: this._numMarquageCtrl,
                        keyboardType: TextInputType.number,
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
                    )),
                    new FilledButton( child: new Text(S.of(context).place_earring,),
                      onPressed: () => this._presenter.createBete(this.widget._currentLamb, _numBoucleCtrl.text, _numMarquageCtrl.text),
                      //color: Colors.lightGreen[900],
                    ),
                  ]
              ),
            )));
  }

  @override
  void initState() {
    if (AuthService().subscribe && defaultTargetPlatform == TargetPlatform.android)
      new Future.delayed(Duration.zero,() {
        this._presenter.startReadBluetooth();
      });
    super.initState();
  }

  Widget _statusBluetoothBar()  {
    if ( ! AuthService().subscribe )
      return Container();
    List<Widget> status = <Widget>[]; //new List();
    if (_bluetoothState.connectionStatus == "CONNECTED")
      switch (_bluetoothState.dataStatus) {
        case "WAITING":
          status.add(Icon(Icons.bluetooth));
          status.add(Expanded(child: LinearProgressIndicator(),));
          break;
        case "AVAILABLE":
          status.add(Icon(Icons.bluetooth));
          status.add(Text(S.of(context).data_available));
      }
    else {
      status.add(Icon(Icons.bluetooth));
      status.add(Text(S.of(context).not_connected));
    }

    return Row(children: status,);
  }

  updateBoucle (BoucleModel numBoucle) {
    setState(() {
      _numBoucleCtrl.text = numBoucle.ordre;
      _numMarquageCtrl.text = numBoucle.marquage;
    });
  }

  @override
  void dispose() {
    _numBoucleCtrl.dispose();
    _numMarquageCtrl.dispose();
    this._presenter.stopReadBluetooth();
    super.dispose();
  }

  void returnBete(Bete bete) {
    Navigator.pop(context, bete);
  }
}