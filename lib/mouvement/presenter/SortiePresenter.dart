import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/mouvement/ui/SortiePage.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/services/MouvementService.dart';



class SortiePresenter {
  final SortieService _service = SortieService();
  final SortieContract _view;

  SortiePresenter(this._view);

  void save(String ? dateSortie, String ? motif) async {
    try {
      String message  = await this._service.saveSortie(dateSortie, motif, this._view.sheeps);
      this._view.backWithMessage(message);
    } on MissingMotif {
      this._view.showMessage (S.current.output_reason_required, true);
    } on MissingSheeps {
      this._view.showMessage (S.current.empty_list, true);
    } on MissingDate {
      this._view.showMessage (S.current.noEntryDate, true);
    }
  }

  Future add() async {
    Bete ? selectedBete = await this._view.goNextPage( SearchPage(GismoPage.sortie));
    if (selectedBete != null) {
      List<Bete> lstBete = this._view.sheeps;
      lstBete.add(selectedBete);
      this._view.sheeps = lstBete;
    }
  }


}