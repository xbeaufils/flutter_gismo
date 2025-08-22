import 'package:flutter/material.dart';
import 'package:flutter_gismo/individu/presenter/EventPresenter.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/ui/LambTimeLine.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';

abstract class EventPage extends StatelessWidget {

  late TimelineContract _view;
  EventPresenter get presenter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot lstEvents){
        if (lstEvents.data == null)
          return Container( child:
          Center(
              child: CircularProgressIndicator()),);
        return ListView.builder ( //.separated(
          //separatorBuilder: (context, index) { return Divider(indent: 16, endIndent: 16,);},
          shrinkWrap: true,
          itemCount: lstEvents.data.length,
          itemBuilder: (context, index) {
            Event event = lstEvents.data[index];
            return ListTile(
              leading: _getImageType(event.type),
              title: Text(event.eventName),
              subtitle: Text(DateFormat.yMd().format(event.date)),
              trailing:this._eventButton(event),
            );
          },
        );
      },
      future: _getEvents(),
    );
  }
  Future _getEvents() ;

  Widget ? _eventButton(Event event) {
    switch (event.type) {
      case EventType.agnelage :
      case EventType.traitement:
      case EventType.echo:
      case EventType.memo:
        return IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: () => presenter.searchEvent(event), );
        break;
      case EventType.saillie:
      case EventType.NEC:
      case EventType.pesee:
        return IconButton(icon: Icon(Icons.delete), onPressed: () => () , );
      default:
    }
    return null;
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

class EventLambPage extends EventPage {
  late EventPresenter _presenter;
  EventPresenter get presenter => _presenter;
  final LambTimelineContract _view;
  final LambModel  _lamb;

  EventLambPage(this._view, this._lamb) {
    _presenter = EventLambPresenter(this._view, this._lamb);
  }

  Future _getEvents() {
    return _presenter.getEvents();
  }
}

class EventSheepPage extends EventPage {
  late EventPresenter _presenter ;
  final TimelineContract _view;
  EventPresenter get presenter => _presenter;

  final Bete  _bete;

  EventSheepPage(this._view, this._bete) {
    _presenter = EventSheepPresenter(this._view, this._bete);
  }

  Future _getEvents() {
    return _presenter.getEvents();
  }
}