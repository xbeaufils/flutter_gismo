import 'package:flutter_gismo/individu/ui/Bete.dart';
import 'package:flutter_gismo/individu/ui/EchoPage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/memo/ui/MemoPage.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';

class TimeLinePresenter {

  BeteService _beteService = BeteService();
  late TimelineContract _view;

  TimeLinePresenter(this._view) {
    _beteService = BeteService();
  }

  Future<List<Bete>> getBetes() {
    return this._beteService.getBetes();
  }

  Future<Bete?> getMere(Bete bete) {
    return this._beteService.getMere(bete);
  }

  Future<Bete?> getPere(Bete bete) {
    return this._beteService.getPere(bete);
  }

  Future<String> deleteEvent(Event event) async {
    String message = await this._beteService.deleteEvent(event);
    return message;
  }

  Future<List<Event>> getEvents(Bete bete) async {
    return this._beteService.getEvents(bete);
  }

  Future<LambingModel?> searchLambing(int idBd) {
    return this._beteService.searchLambing(idBd);
  }

  Future<TraitementModel?> searchTraitement(int idBd) {
    return this._beteService.searchTraitement(idBd);
  }

  void searchEvent(Event event) {
    switch (event.type) {
      case EventType.agnelage :
        this._beteService.searchLambing(event.idBd).then( (lambing) => {_editLambing(lambing!)} );
        break;
      case EventType.traitement:
        this._beteService.searchTraitement(event.idBd).then( (traitement) => { _editTraitement(traitement!)});
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

  void _editLambing(LambingModel lambing) async {
    String ? message = await this._view.editPage(LambingPage.modify(lambing));
    if (message != null)
      this._view.showMessage(message);
  }

  void _editTraitement(TraitementModel traitement) async {
    String ? message = await this._view.editPage(SanitairePage.modify(traitement));
    if (message != null)
      this._view.showMessage(message);
  }

  void _editEcho(EchographieModel echo) async {
    String ? message = await this._view.editPage(EchoPage.modify(echo));
    if (message != null)
      this._view.showMessage(message);
  }

  void _editMemo(MemoModel note) async {
    String ? message = await this._view.editPage(MemoPage.modify(note));
    if (message != null)
      this._view.showMessage(message);
  }

  Future viewBete(Bete bete) async {
    Bete? selectedBete = await this._view.goNextPage( BetePage(bete));
  }

  void viewParent(Bete parent) async {
    String ? message = await this._view.editPage(TimeLinePage( parent));
    /*
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLinePage(_bloc, mere),
      ),
    );
     */
     if (message != null) this._view.showMessage(message);
  }
}