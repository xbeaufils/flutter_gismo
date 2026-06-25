import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/services/CoproService.dart';
import 'package:flutter_gismo/traitement/ui/Copro.dart';
import 'package:flutter_gismo/traitement/ui/CoproList.dart';

class CoproListPresenter {
  CoproListContract _view;
  CoproService _service = CoproService();

  CoproListPresenter(this._view);

  void createCopro(){
    _view.goNextPage(CoproPage(new Prelevement(DateTime.now())));
  }

  void viewDetails(Prelevement prelevement ) async {
    String? message = await this._view.goNextPage(CoproPage(prelevement ));
    if (message != null)
      this._view.showMessage(message);
  }

  void delete(Prelevement prelevement) async {
    bool Ok = await this._view.showDialogOkCancel();
    if (Ok) {
      this._view.showSaving();
      await _service.delete(prelevement);
      this._view.hideSaving();
      this._view.showMessage(S.current.ack_delete_done);
    }
  }

  Future<List<Prelevement>> getPrelevements()  {
    return this._service.getPrelevementsForCheptel();
  }

}