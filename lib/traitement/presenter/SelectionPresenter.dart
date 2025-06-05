import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/traitement/ui/selectionTraitement.dart';

class SelectionPresenter {
  SelectionContract _view;

  SelectionPresenter(this._view);

  Future addMultipleBete() async {
    List<Bete>? betes = await this._view.goNextPage(SelectMultiplePage( GismoPage.sanitaire, this._view.betes));
    debug.log("List $betes");
    if (betes != null)
      setState(() {
        this._lstBete =  List.from( betes as Iterable );
      });
  }

  Future addBete() async {
    Bete ? selectedBete = await  this._view.goNextPage(SearchPage( GismoPage.sanitaire));
    if (selectedBete != null) {
      setState(() {
        Iterable<Bete> existingBete  = _lstBete.where((element) => element.idBd == selectedBete.idBd);
        if (existingBete.isEmpty)
          _lstBete.add(selectedBete);
        else
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(S.of(context).identity_number_error)));
      });
    }
  }

  Future removeBete(Bete selectedBete) async {
    setState(() {
      _lstBete.remove(selectedBete);
    });
  }



}