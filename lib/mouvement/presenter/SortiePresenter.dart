import 'package:gismo/generated/l10n.dart';
import 'package:gismo/Gismo.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/mouvement/ui/SortiePage.dart';
import 'package:gismo/search/ui/SearchPage.dart';
import 'package:gismo/services/MouvementService.dart';



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