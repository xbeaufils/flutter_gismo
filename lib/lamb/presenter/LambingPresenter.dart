
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/lamb/ui/Adoption.dart';
import 'package:flutter_gismo/lamb/ui/AgnelageQualityPage.dart';
import 'package:flutter_gismo/lamb/ui/LambPage.dart';
import 'package:flutter_gismo/lamb/ui/SearchPerePage.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
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
      pere = await this._view.goNextPage(SearchPerePage( currentLambing));
    }
    else {
      SearchPage search = new SearchPage( GismoPage.sailliePere);
      search.searchSex = Sex.male;
      pere = await this._view.goNextPage(search);
    }
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
      this._view.showMessage(S.current.no_lamb, true);
    }
  }

  void addLamb() async {
    LambModel? newLamb = await this._view.goNextPage(LambPage());
    if (newLamb != null) {
      currentLambing.lambs.add(newLamb);
    }
    this._view.hideSaving();
  }

  void editLamb(LambModel lamb) async {
    LambModel? newLamb =  await  this._view.goNextPage(LambPage.edit(lamb));
    if (newLamb == null)
      return;
    String message = await this._service.saveLamb(newLamb);
    this._view.hideSaving();
    this._view.showMessage(message);
  }

  void selectAdoption() async {
    int ? qualiteAdoption = await  this._view.goNextPage(AdoptionDialog(this._view.adoption.key));
    if (qualiteAdoption != null) {
        this._view.adoption = AdoptionHelper.getAdoption(qualiteAdoption);
    }
  }

  void selectQualite() async {
    int ? qualiteAgnelage = await  this._view.goNextPage(AgnelageDialog(this._view.agnelage.key));
    if (qualiteAgnelage != null) {
      this._view.agnelage = AgnelageHelper.getAgnelage(qualiteAgnelage);
    }
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