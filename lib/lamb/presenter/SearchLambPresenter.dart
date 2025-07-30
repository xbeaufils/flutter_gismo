import 'package:gismo/lamb/ui/LambPage.dart';
import 'package:gismo/lamb/ui/SearchLambPage.dart';
import 'package:gismo/model/LambModel.dart';
import 'package:gismo/services/LambingService.dart';

class SearchLambPresenter {
  final LambingService _service = LambingService();
  final SearchLambContract _view;

  SearchLambPresenter(this._view);

  void selectLambs(CompleteLambModel lamb) async  {
    LambModel ? newLamb = await this._view.goNextPage( LambPage.edit( lamb)) as LambModel?;
    if (newLamb == null)
      return;
    this._service.saveLamb(newLamb);
    this._view.lambs.forEach((aLamb) {
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
    String message = await this._service.deleteLamb(lamb);
    this._view.lambs  = await this._service.getAllLambs();
    //setState(() {
      this._view.filteredLambs = this._view.lambs;

    //});
    this._view.showMessage(message);
  }

  void getLambs() async {
    this._view.lambs = await this._service.getAllLambs();
    //setState(() {
      this._view.filteredLambs = this._view.lambs;
    //});
  }

}