
import 'package:flutter_gismo/individu/ui/EchoPage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/ui/LambTimeLine.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/memo/ui/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/LambingService.dart';
import 'package:flutter_gismo/services/TraitementService.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';

abstract class EventService {

}

abstract class EventPresenter {
  final _beteService = BeteService();
  final LambingService _lambingService = LambingService();
  final TraitementService _traitementService = TraitementService();

  TimelineContract get view ;

  Future<List<Event>> getEvents();

  void searchEvent(Event event) {
    switch (event.type) {
      case EventType.agnelage :
        this._beteService.searchLambing(event.idBd).then( (lambing) => {this._editLambing(lambing!)} );
        break;
      case EventType.traitement:
        this._traitementService.searchTraitement(event.idBd).then( (traitement) => { _editTraitement(traitement!)});
        break;
      case EventType.echo:
        this._beteService.searchEcho(event.idBd).then( (echo) => { _editEcho(echo!)});
        break;
      case EventType.memo:
        this._beteService.searchMemo(event.idBd).then( (memo) => { _editMemo(memo!) });
        break;
      case EventType.saillie:
      case EventType.NEC:
      case EventType.pesee:
      default:
    }
  }

  void delete(Event event) async {
    bool ok = await this.view.showDialogOkCancel();
    if (ok) {
      await _beteService.deleteEvent(event);
      this.view.hideSaving();
    }
  }

  void _editLambing(LambingModel lambing) async {
    String ? message = await this.view.editPage(LambingPage.modify(lambing));
    if (message != null)
      this.view.showMessage(message);
    this.view.hideSaving();
  }

  void _editTraitement(TraitementModel traitement) async {
    String ? message = await this.view.editPage(SanitairePage.modify(traitement));
    if (message != null)
      this.view.showMessage(message);
    this.view.hideSaving();
  }

  void _editEcho(EchographieModel echo) async {
    String ? message = await this.view.editPage(EchoPage.modify(echo));
    if (message != null)
      this.view.showMessage(message);
    this.view.hideSaving();
  }

  void _editMemo(MemoModel note) async {
    String ? message = await this.view.editPage(MemoPage.modify(note));
    if (message != null)
      this.view.showMessage(message);
    this.view.hideSaving();
  }
}

class EventSheepPresenter extends EventPresenter {
  TimelineContract _view;
  final Bete  _bete;

  TimelineContract get view => _view;
  EventSheepPresenter(this._view, this._bete);

  Future<List<Event>> getEvents() async {
    return this._beteService.getEvents(_bete);
  }

}

class EventLambPresenter extends EventPresenter {
  final LambTimelineContract _view;
  final LambModel _lamb;
  TimelineContract get view => _view;

  EventLambPresenter(this._view, this._lamb);

  Future<List<Event>> getEvents() async {
    return this._lambingService.getEvents(this._lamb);
  }

  void searchEvent(Event event) async {
    switch (event.type) {
      case EventType.traitement:
        await this._traitementService.searchTraitement(event.idBd).then( (traitement) => { _editTraitement(traitement!)});
        this.view.hideSaving();
        break;
      case EventType.echo:
      case EventType.memo:
      case EventType.saillie:
      case EventType.NEC:
      case EventType.pesee:
      default:
    }
  }


}