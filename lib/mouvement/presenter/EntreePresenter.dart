import 'package:gismo/generated/l10n.dart';
import 'package:gismo/individu/ui/Bete.dart';
import 'package:gismo/mouvement/ui/EntreePage.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/services/MouvementService.dart';

class EntreePresenter {
  final EntreeService _service = EntreeService();
  final EntreeContract _view;

  EntreePresenter(this._view);


  void save(String ? dateEntree, String ? motif) async {
    try {
      String message = await this._service.save(
          dateEntree, motif, this._view.sheeps);
      this._view.backWithMessage(message);
    } on MissingMotif {
      this._view.showMessage (S.current.entree_reason_required, true);
    } on MissingSheeps {
      this._view.showMessage (S.current.empty_list, true);
    } on MissingDate {
      this._view.showMessage (S.current.noEntryDate, true);
    }

  }

  Future add() async {
    Bete? selectedBete = await this._view.goNextPage( BetePage(null));
    if (selectedBete != null) {
      List<Bete> lstBete = this._view.sheeps;
      lstBete.add(selectedBete);
      this._view.sheeps = lstBete;
    }
  }

  void remove(int index) {
    List<Bete> lstBete = this._view.sheeps;
    lstBete.removeAt(index);
    this._view.sheeps = lstBete;
  }

}

