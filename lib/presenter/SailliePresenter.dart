import 'package:flutter_gismo/individu/SailliePage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/services/SaillieService.dart';
import 'package:intl/intl.dart';

class SailliePresenter {
  final SaillieService _service = SaillieService();
  final SaillieContract _view;
  Pere ? pere;

  SailliePresenter(this._view);

  Future addPere() async {
    Bete ? selectedBete = await this._view.selectPere();
    if (selectedBete != null) {
      this.pere = new Pere(selectedBete.idBd!, selectedBete.numBoucle, selectedBete.numMarquage);
    }
  }

  void removePere() {
    this.pere = null;
  }

  void saveSaillie(String dateSaillie) async {
    this._view.showSaving();
    if (this._view.currentSaillie == null)
      this._view.currentSaillie = new SaillieModel();
    this._view.currentSaillie!.idMere = this._view.bete.idBd!;
    this._view.currentSaillie!.dateSaillie = DateFormat.yMd().parse(dateSaillie);
    this._view.currentSaillie!.idPere = this.pere!.idPere;
    String message = await this._service.saveSaillie(this._view.currentSaillie!);
    this._view.backWithMessage(message);
  }

}

class Pere {
  int idPere=-1 ;
  String numBouclePere = "";
  String numMarquagePere = "";

  Pere(this.idPere, this.numBouclePere, this.numMarquagePere);
}