import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Bete.dart';
import 'package:flutter_gismo/Sanitaire.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';


class TimeLinePage extends StatefulWidget {
  final Bete _bete;
  TimeLinePage(this._bete, {Key key}) : super(key: key);
  @override
  _TimeLinePageState createState() => new _TimeLinePageState(_bete);
}

class _TimeLinePageState extends State<TimeLinePage> with SingleTickerProviderStateMixin {

  final _formKeyIdentity = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Bete _bete;
  int _indexExpandedTraitement = -1;

  _TimeLinePageState(this._bete);

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
                  subtitle: Text(_bete.dateEntree),
                  leading: Image.asset("assets/brebis.png") ,
                  trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: _openIdentityDialog, ),)
                ,),
            _getEvents(),
          ],),
    );
  }

  @override
  void initState() {
     super.initState();
  }

  Future _openIdentityDialog() async {
    Bete selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
        builder: (BuildContext context) {
          return new BetePage(_bete);
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
      future: gismoBloc.getEvents(_bete),
    );
  }

  void _searchEvent(Event event) {
    switch (event.type) {
      case EventType.agnelage :
        gismoBloc.searchLambing(event.idBd).then( (lambing) => {_editLambing(lambing)} );
        break;
      case EventType.traitement:
        gismoBloc.searchTraitement(event.idBd).then( (traitement) => { _editTraitement(traitement)});
        break;
      default:
    }
  }

  void _editLambing(LambingModel lambing) {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LambPage.edit(lambing),
      ),
    );
    navigationResult.then( (message) {if (message != null) _showMessage(message);} );

  }

  void _editTraitement(TraitementModel traitement)  {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SanitairePage.edit(traitement),
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

