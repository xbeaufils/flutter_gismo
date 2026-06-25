import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/services/CoproService.dart';
import 'package:flutter_gismo/traitement/ui/Copro.dart';
import 'package:intl/intl.dart';

class CoproPresenter {
  CoproContract _view;
  CoproService _service = CoproService();
  int _currentViewIndex=0;
  int get currentViewIndex => _currentViewIndex;

  CoproPresenter(this._view);

  void save( String dateCopro, String strongleGI, String strongleP, String strongy, String nematode, String trichures, String pDouve, String gDouve, String paramph, String tenia, String coccidie) {
    this._view.showSaving();
    this._view.copro.datePrelevement = DateFormat.yMd().parse(dateCopro);
    if ( ! this._updateResultat(strongleGI, Parasite.STRONGLES_GASTRO_INTESTINAUX)) {
      if (! strongleGI.isEmpty)
        this._view.copro.resultats.add(Resultat.STRONGLES_GASTRO_INTESTINAUX(int.parse(strongleGI)));
    }
    if ( ! this._updateResultat(strongleP, Parasite.STRONGLES_PULMONAIRES)) {
      if (! strongleP.isEmpty)
        this._view.copro.resultats.add(Resultat.STRONGLES_PULMONAIRES(int.parse(strongleP)));
    }
    if (! this._updateResultat(strongy, Parasite.STRONGYLOIDES)) {
      if (! strongy.isEmpty)
        this._view.copro.resultats.add(Resultat.STRONGYLOIDES(int.parse(strongy)));
    }
    if (! this._updateResultat(nematode, Parasite.NEMATODIRUS)) {
      if (! nematode.isEmpty)
        this._view.copro.resultats.add(Resultat.NEMATODIRUS(int.parse(nematode)));
    }
    if (! this._updateResultat(trichures, Parasite.TRICHURES)) {
      if (! trichures.isEmpty)
        this._view.copro.resultats.add(Resultat.TRICHURES(int.parse(trichures)));
    }
    if (! this._updateResultat(pDouve, Parasite.PETITES_DOUVES)) {
      if (! pDouve.isEmpty)
        this._view.copro.resultats.add(Resultat.PETITES_DOUVES(int.parse(pDouve)));
    }
    if (! this._updateResultat(gDouve, Parasite.GRANDES_DOUVES)) {
      if (! gDouve.isEmpty)
        this._view.copro.resultats.add(Resultat.GRANDES_DOUVES(int.parse(gDouve)));
    }
    if (! this._updateResultat(paramph, Parasite.PARAMPHISTOMES)) {
      if (! paramph.isEmpty)
        this._view.copro.resultats.add(Resultat.PARAMPHISTOMES(int.parse(paramph)));
    }
    if (! this._updateResultat(tenia, Parasite.TAENIA)) {
      if (! tenia.isEmpty)
        this._view.copro.resultats.add(Resultat.TAENIA(int.parse(tenia)));
    }
    if (! this._updateResultat(coccidie, Parasite.COCCIDIES)) {
      if (! coccidie.isEmpty)
        this._view.copro.resultats.add(Resultat.COCCIDIES(int.parse(coccidie)));
    }
    _service.save(this._view.copro);
    this._view.hideSaving();
  }

  bool _updateResultat( String value, Parasite parasite) {
    Resultat ? resultat;
    this._view.copro.resultats.forEach( (result) {
      if (result.parasite == parasite)
        resultat = result;
    });
    if (resultat != null) {
      resultat!.quantite = int.tryParse(value);
      return true;
    }
    return false;
  }

  void addBete() async {
    SearchPage search = SearchPage(GismoPage.lot);
    Bete ? selectedBete = await this._view.goNextPage(search);
    if (selectedBete == null)
      return null;
    this._view.copro.betes.add(selectedBete);
  }

  void addMultipleBete() async {
    List<Bete>? betes = await this._view.goNextPage(SelectMultiplePage( GismoPage.sanitaire, this._view.copro.betes));
    if (betes != null)
      this._view.copro.betes = (betes);

  }

  Future<Prelevement> getCopro(int idCopro) async {
    return this._service.getPrelevement(idCopro);
  }

  void removeBete(Bete bete) async {
    bool Ok = await this._view.showDialogOkCancel();
    if ( ! Ok) return;
  }

  void changeTab(int index) {
    this._currentViewIndex = index;
    this._view.hideSaving();
  }
}
