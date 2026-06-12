import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/services/CoproService.dart';
import 'package:flutter_gismo/traitement/ui/Copro.dart';

class CoproPresenter {
  CoproContract _view;
  CoproService _service = CoproService();
  int _currentViewIndex=0;
  int get currentViewIndex => _currentViewIndex;

  CoproPresenter(this._view);

  void save() {
    _service.save(this._view.copro);
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

  void changeTab(int index) {
    this._currentViewIndex = index;
    this._view.hideSaving();
  }
}
