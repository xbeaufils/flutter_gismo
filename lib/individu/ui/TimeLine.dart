import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gismo/individu/ui/Bete.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/core/ui/SimpleGismoPage.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/model/Event.dart';
import 'package:gismo/individu/presenter/TimeLinePresenter.dart';
import 'package:intl/intl.dart';


class TimeLinePage extends StatefulWidget {
  final Bete _bete;
  TimeLinePage(this._bete, {Key ? key}) : super(key: key);
  @override
  _TimeLinePageState createState() => new _TimeLinePageState(_bete);
}

abstract class TimelineContract extends GismoContract {
  Future<String?> editPage(StatefulWidget page );
}

class _TimeLinePageState extends GismoStatePage<TimeLinePage> with SingleTickerProviderStateMixin implements TimelineContract {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TimeLinePresenter _presenter;
  Bete _bete;

  _TimeLinePageState( this._bete);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(S.of(context).sheep),
        ),
      body:
          Column (
            children: <Widget>[
              Card(child:
                ListTile(
                  title: Text(_bete.numBoucle + " " + _bete.numMarquage),
                  subtitle: (_bete.dateEntree!= null) ? Text( DateFormat.yMd().format(_bete.dateEntree)): null,
                  leading: Image.asset("assets/brebis.png") ,
                  trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => this._presenter.viewBete(_bete), ),)
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
     this._presenter  = TimeLinePresenter(this);
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
              subtitle: Text(DateFormat.yMd().format(mere.data.dateEntree)),
              trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => this._presenter.viewParent(mere.data), )),
          );
        },
        future: this._presenter.getMere(_bete),
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
              subtitle: Text(DateFormat.yMd().format(pere.data.dateEntree)),
              trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () =>this._presenter.viewParent(pere.data), )),
        );
      },
      future: this._presenter.getPere(_bete),
    );
  }


  Future _openIdentityDialog() async {
    Bete ? selectedBete = await Navigator.of(context).push(new MaterialPageRoute<Bete>(
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
      builder: (context, AsyncSnapshot lstEvents){
        if (lstEvents.data == null)
          return Container( child:
            Center(
              child: CircularProgressIndicator()),);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: lstEvents.data.length,
          itemBuilder: (context, index) {
            Event event = lstEvents.data[index];
            return new ListTile(
              leading: _getImageType(event.type),
              title: Text(event.eventName),
              subtitle: Text(DateFormat.yMd().format(event.date)),
              trailing:this._eventButton(event),
            );
          },
        );
      },
      future: this._presenter.getEvents(_bete),
    );
  }

  Widget ? _eventButton(Event event) {
    switch (event.type) {
      case EventType.agnelage :
      case EventType.traitement:
      case EventType.echo:
      case EventType.memo:
        return IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => this._presenter.searchEvent(event), );
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
     return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
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
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(Event event) {
    return TextButton(
      child: Text(S.of(context).bt_continue),
      onPressed: ()  {
        if (event.type == EventType.pesee || event.type == EventType.NEC || event.type == EventType.saillie)
          setState(() async {
            String message = await this._presenter.deleteEvent(event);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          });
        Navigator.of(context).pop();
      },
    );
  }

  Future<String ?> editPage(StatefulWidget page ) async {
    String ? message = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
    return message;
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

 }

