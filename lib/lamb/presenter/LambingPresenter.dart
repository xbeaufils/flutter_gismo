
import 'package:flutter_gismo/lamb/ui/SearchPerePage.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/LambingService.dart';
import 'package:intl/intl.dart';

class LambingPresenter {
  final LambingService _service = LambingService();
  final LambingContract _view;

  LambingPresenter(this._view);

  LambingModel get currentLambing => this._view.currentLambing;

  void addPere() async {
    Bete ? pere;
    if (AuthService().subscribe) {
        pere = await this._view.showPerePage();
      }
      else
        pere = await this._view.searchPere();
    if (pere != null) {
      currentLambing.numBouclePere = pere.numBoucle;
      currentLambing.numMarquagePere = pere.numMarquage;
      currentLambing.idPere = pere.idBd;
    } else {
      currentLambing.numBouclePere = null;
      currentLambing.numMarquagePere = null;
      currentLambing.idPere = null;
    }
    this._view.refreshLambing(currentLambing);
  }

  void removePere() {
      currentLambing.numBouclePere=  null;
      currentLambing.numMarquagePere = null;
      currentLambing.idPere = null;
      this._view.refreshLambing(currentLambing);
  }

  void saveLambing(String dateAgnelage, String obs, int adoption, int qualite ) async {
    currentLambing.setDateAgnelage(DateFormat.yMd().parse(dateAgnelage));
    currentLambing.observations = obs;
    currentLambing.adoption = adoption;
    currentLambing.qualite = qualite;
    String ? message  = null;
    try {
      String ? message  =  await this._service.saveLambing(this.currentLambing);
      if (message != null) this._view.backWithMessage(message);
    } on NoLamb catch(e){
      throw e;
    }
  }

  Future addLamb() async {
    LambModel? newLamb = await this._view.addLamb();
    if (newLamb != null) {
      currentLambing.lambs.add(newLamb);
    }
  }

  void editLamb(LambModel lamb, String dateNaissance) async {
    LambModel? newLamb = await this._view.editLamb(lamb, dateNaissance);
    if (newLamb == null)
      return;
    this._service.saveLamb(newLamb);
    currentLambing.lambs.forEach((aLamb) {
      if (aLamb.idBd == newLamb.idBd) {
        aLamb.sex = newLamb.sex;
        aLamb.allaitement = newLamb.allaitement;
        aLamb.marquageProvisoire = newLamb.marquageProvisoire;
        aLamb.dateDeces = newLamb.dateDeces;
        aLamb.motifDeces = newLamb.motifDeces;
        aLamb.numBoucle = newLamb.numBoucle;
        aLamb.numMarquage = newLamb.numMarquage;
      }
    });
    this._view.refreshLambing(currentLambing);
  }



}

class SearchPerePresenter {
  final LambingService _service = LambingService();
  final BeteService _beteService = BeteService();

  final SearchPereContract _view;

  SearchPerePresenter(this._view);

  Future<List<Bete>> getBeliers(View currentView, LambingModel lambing )  {
    switch (currentView) {
      case View.lot:
        return this._service.getLotBeliers(lambing);
      case View.saillie :
        return  this._service.getSaillieBeliers(lambing) ;
      case View.all:
        return this._beteService.getBeliers();
    }
  }

}