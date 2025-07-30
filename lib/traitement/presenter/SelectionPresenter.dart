import 'package:gismo/Gismo.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/search/ui/SearchPage.dart';
import 'package:gismo/search/ui/SelectMultiplePage.dart';
import 'package:gismo/traitement/ui/Sanitaire.dart';
import 'package:gismo/traitement/ui/selectionTraitement.dart';

class SelectionPresenter {
  SelectionContract _view;

  SelectionPresenter(this._view);

  void openTraitement() async {
    String ? message = await this._view.goNextPage( SanitairePage.collectif( this._view.betes ));
    if (message != null)
      this._view.backWithMessage(message);
    else
      this._view.back();
  }

  Future addMultipleBete() async {
    List<Bete>? betes = await this._view.goNextPage(SelectMultiplePage( GismoPage.sanitaire, this._view.betes));
    if (betes != null)
      this._view.betes = (betes!);
  }

  Future addBete() async {
    Bete ? selectedBete = await  this._view.goNextPage(SearchPage( GismoPage.sanitaire));
    if (selectedBete != null) {
        Iterable<Bete> existingBete  = this._view.betes.where((element) => element.idBd == selectedBete.idBd);
        if (existingBete.isEmpty) {
          List<Bete> newList = this._view.betes;
          newList.add(selectedBete);
          this._view.betes = newList;
        }
     }
  }

  Future removeBete(Bete selectedBete) async {
    this._view.betes.remove(selectedBete);
  }



}