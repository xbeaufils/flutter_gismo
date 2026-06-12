import 'package:flutter_gismo/model/copro.dart';
import 'package:flutter_gismo/services/CoproService.dart';
import 'package:flutter_gismo/traitement/ui/Copro.dart';
import 'package:flutter_gismo/traitement/ui/CoproList.dart';

class Coprolistpresenter {
  CoproListContract _view;
  CoproService _service = CoproService();

  Coprolistpresenter(this._view);

  void createLot(){
    _view.goNextPage(CoproPage(new Prelevement()));
  }

  void viewDetails(Prelevement prelevement ) async {
    String? message = await this._view.goNextPage(CoproPage(prelevement ));
    if (message != null)
      this._view.showMessage(message);
  }

  void delete(Prelevement prelevement) async {
    bool Ok = await this._view.showDialogOkCancel();
    if (Ok) {
      var message = await _service.delete(prelevement);
      if (message != null)
        this._view.showMessage(message);
    }
  }

  Future<List<Prelevement>> getPrelevements()  {
    return this._service.getPrelevementsForCheptel();
  }

}