import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';
import 'package:flutter_gismo/traitement/ui/selectionTraitement.dart';

class SelectionPresenter {
  SelectionContract _view;

  SelectionPresenter(this._view);

  void openTraitement() async {
    String message = await this._view.goNextPage( SanitairePage.collectif( this._view.betes ));
    this._view.backWithMessage(message);
  }

  Future addMultipleBete() async {
    List<Bete>? betes = await this._view.goNextPage(SelectMultiplePage( GismoPage.sanitaire, this._view.betes));
    this._view.betes = (betes!);
  }

  Future addBete() async {
    Bete ? selectedBete = await  this._view.goNextPage(SearchPage( GismoPage.sanitaire));
    if (selectedBete != null) {
        Iterable<Bete> existingBete  = this._view.betes.where((element) => element.idBd == selectedBete.idBd);
        if (existingBete.isEmpty)
          this._view.betes.add(selectedBete);
     }
  }

  Future removeBete(Bete selectedBete) async {
    this._view.betes.remove(selectedBete);
  }



}