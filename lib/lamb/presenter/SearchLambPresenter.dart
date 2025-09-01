import 'package:flutter_gismo/lamb/ui/LambPage.dart';
import 'package:flutter_gismo/lamb/ui/LambTimeLine.dart';
import 'package:flutter_gismo/lamb/ui/SearchLambPage.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/services/LambingService.dart';

class SearchLambPresenter {
  final LambingService _service = LambingService();
  final SearchLambContract _view;
  List<CompleteLambModel> _lambs = <CompleteLambModel>[];
  SearchLambPresenter(this._view);

  void selectLambs(CompleteLambModel lamb) async  {
    LambModel ? newLamb = await this._view.goNextPage( LambTimeLinePage(lamb)) as LambModel?;
    if (newLamb == null)
      return;
    //this._service.saveLamb(newLamb);
    this._lambs.forEach((aLamb) {
      if (aLamb.idBd == newLamb.idBd) {
        aLamb.sex = newLamb.sex;
        aLamb.allaitement = newLamb.allaitement;
        aLamb.marquageProvisoire = newLamb.marquageProvisoire;
        aLamb.dateDeces = newLamb.dateDeces;
        aLamb.motifDeces = newLamb.motifDeces;
        aLamb.numBoucle = newLamb.numBoucle;
        aLamb.numMarquage = newLamb.numMarquage;
      }
    });
  }

  void deleteLamb(CompleteLambModel lamb) async {
    bool ok = await this._view.showDialogOkCancel();
    if (ok) {
      String message = await this._service.deleteLamb(lamb);
      this._view.hideSaving();
      this._view.showMessage(message);
    }
  }

  void getLambs() async {
    this._lambs = await this._service.getAllLambs();
    this._view.filteredLambs = this._lambs;
  }

  void filtre(String text) {
    List<CompleteLambModel> tempList = <CompleteLambModel>[]; //new List();
    for (int i = 0; i < _lambs.length; i++) {
      if (_lambs[i].marquageProvisoire != null) {
        if (_lambs[i].marquageProvisoire!.isNotEmpty) {
          if (_lambs[i].marquageProvisoire!.toLowerCase().contains(
              text.toLowerCase())) {
            tempList.add(_lambs[i]);
          }
        }
      }
    }
    this._view.filteredLambs = tempList;

  }
}