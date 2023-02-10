import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Bete.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/individu/EchoPage.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/traitement/Sanitaire.dart';


class TimeLinePage extends StatefulWidget {
  final Bete _bete;
  final GismoBloc _bloc;
  TimeLinePage(this._bloc, this._bete, {Key ? key}) : super(key: key);
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
              _getPere(),
              Expanded(child: _getEvents()),
          ],),
    );
  }

  @override
  void initState() {
     super.initState();
  }

  Widget _getMere() {
    return FutureBuilder(
        builder: (context, AsyncSnapshot mere){
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

  Widget _getPere() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot pere){
        if (pere.data == null)
          return Container();
        return Card(
          child: ListTile(
              leading: Image.asset("assets/belier.png"),
              title: Text(pere.data.numBoucle + " " + pere.data.numMarquage),
              subtitle: Text(pere.data.dateEntree),
              trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => _viewMere(pere.data), )),
        );
      },
      future: this._bloc.getPere(_bete),
    );
  }


  Future _openIdentityDialog() async {
    Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
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
      builder: (context, AsyncSnapshot lstEvents){
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
              trailing:this._eventButton(event),
            );
          },
        );
      },
      future: this._bloc.getEvents(_bete),
    );
  }

  Widget ? _eventButton(Event event) {
    switch (event.type) {
      case EventType.agnelage :
      case EventType.traitement:
      case EventType.echo:
      case EventType.memo:
        return IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => _searchEvent(event), );
        break;
      case EventType.saillie:
      case EventType.NEC:
      case EventType.pesee:
        return IconButton(icon: Icon(Icons.delete), onPressed: () => _showDialog(context, event), );
      default:
    }
    return null;
  }

  Future _showDialog(BuildContext context, Event event) {
    String message ="Voulez vous supprimer ";
    if (event.type == EventType.NEC)
      message += "cette note d'Etat corp ?";
    if (event.type == EventType.saillie)
      message += "cette saillie ?";
    if (event.type == EventType.pesee)
      message += "cette pesée ?";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Suppression"),
          content: Text(
              message),
          actions: [
            _cancelButton(),
            _continueButton(event),
          ],
        );
      },
    );
  }
  
  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(Event event) {
    return TextButton(
      child: Text("Continuer"),
      onPressed: () {
        if (event.type == EventType.pesee || event.type == EventType.NEC || event.type == EventType.saillie)
          _deleteEvent(event);
        Navigator.of(context).pop();
      },
    );
  }

  void _deleteEvent(Event event) async {
    String message = await this.widget._bloc.deleteEvent(event);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    /*_scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(message)));*/
    setState(() {

    });
  }

  void _searchEvent(Event event) {
    switch (event.type) {
      case EventType.agnelage :
        _bloc.searchLambing(event.idBd).then( (lambing) => {_editLambing(lambing!)} );
        break;
      case EventType.traitement:
        _bloc.searchTraitement(event.idBd).then( (traitement) => { _editTraitement(traitement!)});
        break;
      case EventType.echo:
        _bloc.searchEcho(event.idBd).then( (echo) => { _editEcho(echo!)});
        break;
      case EventType.memo:
        _bloc.searchMemo(event.idBd).then( (memo) => { _editMemo(memo!) });
        break;
      case EventType.saillie:
      case EventType.NEC:
      case EventType.pesee:
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
    navigationResult.then( (message) {
      setState(() {
        if (message != null)
          _showMessage(message);
      });
    } );

  }

  void _editTraitement(TraitementModel traitement)  {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SanitairePage.edit(_bloc, traitement),
      ),
    );
    navigationResult.then( (message) {
      if (message != null)
        setState(() {
          _showMessage(message);
        });
    } );
  }

  void _editEcho(EchographieModel  echo)  {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EchoPage.edit(_bloc, echo, _bete),
      ),
    );
    navigationResult.then( (message) {
      setState(() {
        if (message != null)
          _showMessage(message);
        });
     });
  }

  void _editMemo(MemoModel memo)  {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoPage.edit(_bloc, memo),
      ),
    );
    navigationResult.then( (message) {
      setState(() {
        if (message != null)
          _showMessage(message);
      });
    });
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
      case EventType.agnelage :
        return new Image.asset("assets/lamb.png");
      case EventType.NEC:
        return new Image.asset("assets/etat_corporel.png");
      case EventType.entreeLot:
        return new Image.asset("assets/Lot_entree.png");
      case EventType.sortieLot:
        return new Image.asset("assets/Lot_sortie.png");
      case EventType.pesee:
        return new Image.asset("assets/peseur.png");
      case EventType.echo:
        return new Image.asset("assets/ultrasound.png");
      case EventType.saillie:
        return new Image.asset("assets/saillie.png");
      case EventType.memo:
        return new Image.asset("assets/memo.png");
      case EventType.entree:
      case EventType.sortie:
     }
    return Container();
  }

  void _showMessage(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

