import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';

class SelectMultiplePresenter {
  SelectMultipleContract _view;
  BeteService _service = BeteService();

  SelectMultiplePresenter(this._view);

  void sendSelecttion(List<Bete> betes) {
    GismoPage ? page;
    switch (this._view.nextPage) {
      case GismoPage.sanitaire:
        page = null; //SelectionPage(this._bloc, betes);
        break;
      default :
        page = null;
        break;
    }

    if (page  == null) {
      this._view.goPreviousPage(betes);
    }
    else {
      var navigationResult = this._view.goNextPage(SanitairePage.collectif(this._view.betes));
      navigationResult.then((message) {
        if (message != null)
          this._view.showMessage(message);
      });
    }
  }

  void getBetes() async {
    List<Bete> ? lstBetes ;
    if (this._view.searchSex == null) {
      lstBetes = await this._service.getBetes();
    }
    else {
      switch (this._view.searchSex) {
        case Sex.femelle:
          lstBetes = await this._service.getBrebis();
          break;
        case Sex.male :
          lstBetes = await this._service.getBeliers();
          break;
        default :
          lstBetes = await this._service.getBetes();
      }
    }
    this._view.fillList(lstBetes);
  }


}