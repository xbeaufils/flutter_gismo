import 'package:flutter_gismo/Lot/ui/LotAffectationViewPage.dart';
import 'package:flutter_gismo/Lot/ui/LotPage.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/services/LotService.dart';

class LotPresenter {
  LotContract _view;
  LotService _service = LotService();

  LotPresenter(this._view);

  void createLot(){
    _view.goNextPage(LotAffectationViewPage(new LotModel()));
  }

  Future<void> viewDetails(LotModel lot ) async {
    String? message = await this._view.goNextPage(LotAffectationViewPage(lot ));
    if (message != null)
      this._view.showMessage(message);
  }

  Future<void> delete(LotModel lot) async {
    bool Ok = await this._view.showDialogOkCancel();
    if (Ok) {
      try {
      var message = await _service.deleteLot(lot);
      if (message != null)
        this._view.showMessage(message);
      } on GismoException catch(e) {
        this._view.showMessage(e.message, true);
      }
    }
  }

  Future<List<LotModel>> getLots()  {
    return this._service.getLots();
  }

}