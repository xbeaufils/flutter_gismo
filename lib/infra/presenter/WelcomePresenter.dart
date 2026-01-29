
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/services/MemoService.dart';

class WelcomePresenter {

  final WelcomeContract _view;
  final MemoService _service = MemoService();

  WelcomePresenter(this._view);


  void parcellePressed() {
    _view.viewPage('/parcelle');
  }

  void individuPressed() {
    _view.viewPage('/search');
  }

  void sortiePressed() {
    _view.viewPageMessage( '/sortie');
  }

  void entreePressed() {
    _view.viewPageMessage('/entree') ;
  }

  void traitementPressed() {
    _view.viewPage('/sanitaire');
  }

  void echoPressed() {
    _view.viewPage('/echo');
  }

  void lambingPressed() {
    _view.viewPage('/lambing');
  }

  void lambPressed() {
    _view.viewPage('/lamb');
  }

  void necPressed() {
    _view.viewPage('/nec');
  }

  void peseePressed() {
    _view.viewPage('/pesee');
  }

  void lotPressed() {
    _view.viewPage('/lot');
  }

  void sailliePressed() {
    _view.viewPage('/saillie');
  }
  void notePressed() {
    _view.viewPage('/note') ;
  }

  Future<List<MemoModel>> getNbNotes() {
    return  this._service.getCheptelMemos();
  }
}