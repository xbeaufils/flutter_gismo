import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BoucleModel.dart';
import 'package:flutter_gismo/individu/presenter/BetePresenter.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:sentry/sentry.dart';


class BetePage extends StatefulWidget {
  late Bete _bete;

  BetePage( Bete ? bete, {Key ? key}) : super(key: key) {
    if (bete == null)
      this._bete = Bete.create();
    else
      this._bete = bete;
  }

  @override
  _BetePageState createState() => new _BetePageState();
}

abstract class BeteContract extends GismoContract {
  Bete get bete;

  set bete(Bete value);

  void backWithBete();

  BtcConnectionState get bluetoothState;

  set bluetoothState(BtcConnectionState value);

  void updateBoucle(BoucleModel _foundBoucle);
}

class _BetePageState extends GismoStatePage<BetePage> implements BeteContract {
  DateTime _selectedDate = DateTime.now();
  late BetePresenter _presenter;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');
  bool _rfidPresent = false;
  BtcConnectionState _bluetoothState = BtcConnectionState.disconnected;
  TextEditingController _numBoucleCtrl = new TextEditingController();
  TextEditingController _numMarquageCtrl = new TextEditingController();

  _BetePageState();

  Widget _statusBluetoothBar() {
    if (! AuthService().subscribe)
      return Container();
    List<Widget> status = [];
    switch (_bluetoothState ) {
      case BtcConnectionState.disconnected:
      case BtcConnectionState.disconnecting:
        status.add(Icon(Icons.bluetooth));
        status.add(Text(S.of(context).not_connected));
        break;
      case BtcConnectionState.connected:
      case BtcConnectionState.connecting:
        status.add(Icon(Icons.bluetooth));
        status.add(Expanded( child: LinearProgressIndicator(),) );
        break;
    }
    return Row(children: status,);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(S.of(context).sheep),

        ),
        floatingActionButton: _buildRfid(),
        body:
          Container(
            child:
              SingleChildScrollView ( child:
                Column (children: [
                  Card(child: _statusBluetoothBar(),),
                  Card (
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(children: [
                        Flexible( child:
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                              TextField( /* Numéro boucle */
                                controller: this._numBoucleCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  Theme.of(context).colorScheme.surfaceContainerHighest,
                                    labelText: S.of(context).identity_number,
                                    hintText: S.of(context).identity_number_hint),
                                onChanged: (value) {
                                    setState(() {
                                      this.bete.numBoucle = value;
                                      this._numBoucleCtrl.text = value;
                                  });
                                }
                              ),)),
                        Flexible(child:
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                              TextField( // Numéro Marquage
                                controller: this._numMarquageCtrl,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  Theme.of(context).colorScheme.surfaceContainerHighest,
                                    labelText: S.of(context).flock_number,
                                    hintText: S.of(context).flock_number_hint),
                                onChanged: (value) {
                                  setState(() {
                                    this.bete.numMarquage = value;
                                    this._numMarquageCtrl.text = value;
                                  });
                                })))
                      ],),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        TextFormField( // Nom
                          //keyboardType: TextInputType.number,
                            initialValue: this.bete.nom,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:  Theme.of(context).colorScheme.surfaceContainerHighest,
                                labelText: S.of(context).name,
                                hintText: S.of(context).name_hint),
                            onChanged:(value) => this.bete.nom =value ,
                        )),
                      Row(
                         children: <Widget>[
                            Flexible (child:
                              RadioListTile<Sex>(
                                title: Text(S.of(context).male),
                                selected: bete.sex == Sex.male,
                                value: Sex.male,
                                groupValue: bete.sex,
                                onChanged: (Sex ? value) { setState(() { if (value != null ) bete.sex = value; }); },
                              ),
                          ),
                            Flexible( child:
                              RadioListTile<Sex>(
                                title: Text(S.of(context).female),
                                selected: bete.sex == Sex.femelle,
                                value: Sex.femelle,
                                groupValue: bete.sex,
                                onChanged: (Sex ? value) { setState(() { if (value != null ) bete.sex = value; }); },
                              ),
                          ),]
                      )])),
                  this._buildRace(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                          TextFormField(
                            initialValue: bete.observations,
                            decoration: InputDecoration(
                                labelText: S.of(context).observations,
                                hintText: 'Obs',
                                filled: true,
                                fillColor:  Theme.of(context).colorScheme.surfaceContainerHighest,
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder()),
                            maxLines: 3,
                            onChanged: (value)  => bete.observations = value,)
                  ),
                  (this.bete.idBd == null)?
                  FilledButton(
                      child: new Text(S.of(context).bt_add),
                      onPressed: () => this._presenter.add()
                  ):
                  FilledButton(
                      onPressed: () => this._presenter.save(),
                      child: Text( S.of(context).bt_save,)),
        ]))
    ));
  }

  Widget _buildRace() {
    if (! AuthService().subscribe)
      return Container();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          ListTile(

            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            title: Text(S.of(context).genetic, ),
            trailing: new IconButton(key: Key("btRace"), onPressed: () {
              setState(() {
                this._presenter.selectRace();
              });
            },
            icon: new Icon(Icons.create)),),
          ListTile(
            title: Text(S.of(context).generation),
            subtitle: this._buildGeneration(),
          ),
          ListTile(
            title: Text(S.of(context).race, ),
            subtitle: Container(child: this._buildRaces(),),
          )
      ]),),);
  }

  Widget _buildRaces() {
     if (this.bete.genetique == null)
      return Container();
    if (this.bete.genetique!.races.length == 0)
      return Container();
    return Wrap(children: this.bete.genetique!.races.map((Race race){
      return InputChip(
          label: Text(race.nom),
          onDeleted: () {
            setState(() {
              this._presenter.delete(race);
            });
          }
        );
    }).toList(),)  ;
  }

  Widget _buildGeneration() {
    if (this.bete.genetique == null)
      return Container();
    switch (this.bete.genetique!.niveau) {
      case Generation.PURE:
        return Text("Pur");
      case Generation.F1:
        return Text("F1");
      case Generation.F2:
        return Text("F2");
      case Generation.F3:
        return Text("F3");
      case Generation.F4:
        return Text("F4");
      case Generation.INDETERMINE:
        return Container();
    }
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
          this.bete.numMarquage = mpResponse['marquage'];
        });
      }
      else {
        showMessage("Pas de boucle lue", true);
      }
    } on PlatformException catch (e) {
      showMessage("Pas de boucle lue", true);
    } on Exception catch (e, stackTrace) {
      showMessage(e.toString(), true);
      Sentry.captureException(e, stackTrace : stackTrace);
    }
  }

  @override
  void initState() {
    super.initState();
    this._presenter = BetePresenter(this);
    if (this.widget._bete.numBoucleOrNull != null)
      this._numBoucleCtrl.text = this.widget._bete.numBoucle ;
    if (this.widget._bete.numMarquageOrNull != null)
      this._numMarquageCtrl.text = this.widget._bete.numMarquage;
    if (AuthService().subscribe)
      this._presenter.startReadBluetooth();
    if (this.bete.dateEntree == null )
      this.bete.dateEntree = _selectedDate;
  }

   @override
  void dispose() {
    // other dispose methods
    this._presenter.stopReadBluetooth();
    this._numBoucleCtrl.dispose();
    //this._numMarquageCtrl.dispose();
    super.dispose();
  }

  void backWithBete() {
    Navigator.of(context).pop(this.bete);
  }

  @override
  Bete get bete => this.widget._bete;

   set bete(Bete value) {
     this.widget._bete = value;
   }

  BtcConnectionState get bluetoothState => _bluetoothState;

   set bluetoothState(BtcConnectionState value) {
     setState(() {
       _bluetoothState = value;
     });
   }

  void updateBoucle(BoucleModel _foundBoucle) {
    setState(() {
      this._numBoucleCtrl.text = _foundBoucle.ordre;
      this.bete.numBoucle = _foundBoucle.ordre;
      this._numMarquageCtrl.text = _foundBoucle.marquage;
      this.bete.numMarquage = _foundBoucle.marquage;
    });
  }

}

