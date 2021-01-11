import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Bete.dart';
import 'package:flutter_gismo/Sanitaire.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/individu/EchoPage.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';


class TimeLinePage extends StatefulWidget {
  final Bete _bete;
  final GismoBloc _bloc;
  TimeLinePage(this._bloc, this._bete, {Key key}) : super(key: key);
  @override
  _TimeLinePageState createState() => new _TimeLinePageState(this._bloc, _bete);
}

class _TimeLinePageState extends State<TimeLinePage> with SingleTickerProviderStateMixin {

  final _formKeyIdentity = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;

  Bete _bete;
  int _indexExpandedTraitement = -1;

  _TimeLinePageState(this._bloc, this._bete);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Individu'),
        ),
      body:
          Column (
            children: <Widget>[
              Card(child:
                ListTile(
                  title: Text(_bete.numBoucle + " " + _bete.numMarquage),
                  subtitle: (_bete.dateEntree!= null) ? Text(_bete.dateEntree): null,
                  leading: Image.asset("assets/brebis.png") ,
                  trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: _openIdentityDialog, ),)
                ,),
              _getMere(),
            _getEvents(),
          ],),
    );
  }

  @override
  void initState() {
     super.initState();
  }

  Widget _getMere() {
    return FutureBuilder(
        builder: (context, mere){
          if (mere.data == null)
            return Container();
          return Card(
            child: ListTile(
              leading: Image.asset("assets/sheep_lamb.png"),
              title: Text(mere.data.numBoucle + " " + mere.data.numMarquage),
              subtitle: Text(mere.data.dateEntree),
              trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => _viewMere(mere.data), )),
          );
        },
        future: this._bloc.getMere(_bete),
    );
  }

  Future _openIdentityDialog() async {
    Bete selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          return new BetePage(this._bloc, _bete);
        },
        fullscreenDialog: true
    ));
    if (selectedBete != null) {
      setState(() {
        _bete = selectedBete;
      });
    }
  }

  Widget _getEvents() {
    return FutureBuilder(
      builder: (context, lstEvents){
        if (lstEvents.data == null)
          return Container();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: lstEvents.data.length,
          itemBuilder: (context, index) {
            Event event = lstEvents.data[index];
            return new ListTile(
              leading: _getImageType(event.type),
              title: Text(event.eventName),
              subtitle: Text(event.date),
              trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => _searchEvent(event), )
            );

          },
        );
      },
      future: this._bloc.getEvents(_bete),
    );
  }

  void _searchEvent(Event event) {
    switch (event.type) {
      case EventType.agnelage :
        _bloc.searchLambing(event.idBd).then( (lambing) => {_editLambing(lambing)} );
        break;
      case EventType.traitement:
        _bloc.searchTraitement(event.idBd).then( (traitement) => { _editTraitement(traitement)});
        break;
      case EventType.echo:
        _bloc.searchEcho(event.idBd).then( (echo) => { _editEcho(echo)});
        break;
       default:
    }
  }

  void _editLambing(LambingModel lambing) {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LambingPage.edit(_bloc, lambing),
      ),
    );
    navigationResult.then( (message) {if (message != null) _showMessage(message);} );

  }

  void _editTraitement(TraitementModel traitement)  {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SanitairePage.edit(_bloc, traitement),
      ),
    );
    navigationResult.then( (message) { if (message != null) _showMessage(message);} );
  }

  void _editEcho(EchographieModel  echo)  {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EchoPage.edit(_bloc, echo, _bete),
      ),
    );
    navigationResult.then( (message) { if (message != null) _showMessage(message);} );
  }

  void _viewMere(Bete mere) {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLinePage(_bloc, mere),
      ),
    );
    navigationResult.then( (message) { if (message != null) _showMessage(message);} );
  }

  Widget _getImageType(EventType type) {
    switch (type) {
      case EventType.traitement :
        return new Image.asset("assets/syringe.png");
        break;
      case EventType.agnelage :
        return new Image.asset("assets/lamb.png");
        break;
      case EventType.NEC:
        return new Image.asset("assets/etat_corporel.png");
        break;
      case EventType.entreeLot:
        return new Image.asset("assets/Lot_entree.png");
        break;
      case EventType.sortieLot:
        return new Image.asset("assets/Lot_sortie.png");
        break;
      case EventType.pesee:
        return new Image.asset("assets/peseur.png");
        break;
      case EventType.echo:
        return new Image.asset("assets/ultrasound.png");
      case EventType.entree:
      case EventType.sortie:
     }
    return null;
  }

  void _showMessage(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

