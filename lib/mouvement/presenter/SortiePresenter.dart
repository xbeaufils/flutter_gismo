import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/mouvement/presenter/EntreePresenter.dart';
import 'package:flutter_gismo/mouvement/ui/SortiePage.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/services/MouvementService.dart';
import 'package:intl/intl.dart';



class SortiePresenter {
  final SortieService _service = SortieService();
  final SortieContract _view;

  SortiePresenter(this._view);

  void save(String ? dateSortie, String ? motif) async {
    if (dateSortie == null)
      throw MissingDate();

    if (dateSortie.isEmpty) {
      throw MissingDate();
    }

    if ( motif == null) {
      throw MissingMotif();
    }
    if (motif.isEmpty) {
      throw MissingMotif();
    }
    if (this._view.sheeps.length == 0) {
      throw MissingSheeps();
    }

    String message  = await this._service.saveSortie(DateFormat.yMd().parse(dateSortie), motif, this._view.sheeps);
    this._view.backWithMessage(message);
  }

  Future add() async {
    Bete ? selectedBete = await this._view.goNextPage( SearchPage(GismoPage.sortie));
    if (selectedBete != null) {
        this._view.sheeps.add(selectedBete);
    }
  }


}