
import 'package:flutter/material.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_gismo/model/Dashboard.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/MemoService.dart';

class WelcomePresenter {

  final WelcomeContract _view;
  final MemoService _service = MemoService();
  final BeteService _beteService = BeteService();

  WelcomePresenter(this._view);


  void parcellePressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/parcelle');
  }

  void individuPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/search');
  }

  void sortiePressed() {
  //  Navigator.pop(this._view.context);
    _view.viewPageMessage( '/sortie');
  }

  void entreePressed() {
    Navigator.pop(this._view.context);
    _view.viewPageMessage('/entree') ;
  }

  void traitementPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/sanitaire');
  }

  void echoPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/echo');
  }

  void lambingPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/lambing');
  }

  void lambPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/lamb');
  }

  void necPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/nec');
  }

  void peseePressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/pesee');
  }

  void lotPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/lot');
  }

  void sailliePressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/saillie');
  }
  void notePressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/note') ;
  }

  void geneticPressed() {
    Navigator.pop(this._view.context);
    _view.viewPage('/genetic');
  }

  Future<List<MemoModel>> getNbNotes() {
    return  this._service.getCheptelMemos();
  }

  Future<DashBoardEffectif> getDashBoardEffectif() {
    return  this._beteService.getDashBoardEffectif();
  }

}