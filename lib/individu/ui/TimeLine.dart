import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/individu/ui/Bete.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/individu/ui/EventPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/individu/presenter/TimeLinePresenter.dart';
import 'package:intl/intl.dart';


class TimeLinePage extends StatefulWidget {
  final Bete _bete;
  TimeLinePage(this._bete, {Key ? key}) : super(key: key);
  @override
  _TimeLinePageState createState() => new _TimeLinePageState();
}

abstract class TimelineContract extends GismoContract {
  Future<String?> editPage(StatefulWidget page );
}

class _TimeLinePageState extends GismoStatePage<TimeLinePage> with SingleTickerProviderStateMixin implements TimelineContract {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TimeLinePresenter _presenter;

  _TimeLinePageState( );

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
                  title: Text(this.widget._bete.numBoucle + " " + this.widget._bete.numMarquage),
                  subtitle: (this.widget._bete.dateEntree!= null) ? Text( DateFormat.yMd().format(this.widget._bete.dateEntree)): null,
                  leading: Image.asset("assets/brebis.png") ,
                  trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => this._presenter.viewBete(this.widget._bete), ),)
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
        future: this._presenter.getMere(this.widget._bete),
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
      future: this._presenter.getPere(this.widget._bete),
    );
  }


  Widget _getEvents() {
    return EventSheepPage(this, this.widget._bete);
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


 }

