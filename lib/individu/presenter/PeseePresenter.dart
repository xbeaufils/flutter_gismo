
import 'package:flutter/material.dart';
import 'package:flutter_gismo/individu/ui/PeseePage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/services/PeseeService.dart';
import 'package:intl/intl.dart';

class PeseePresenter extends ChangeNotifier {
  PeseeContract _view;
  PeseeService _service = PeseeService();
  PeseePresenter(this._view);

  void savePesee(String datePesee, String poidsTxt) async {
    double? poids = double.tryParse(poidsTxt);
    String message="";
    if (poids == null) {
      message = "";
      this._view.showMessage(S.current.weighing_error, true);
      return;
    }
    this._view.showSaving();
    if (this._view.bete != null)
      message = await this._service.savePesee(this._view.bete!, poids, DateFormat.yMd().parse( datePesee) );
    if (this._view.lamb != null)
      message = await this._service.savePeseeLamb(this._view.lamb!, poids, DateFormat.yMd().parse( datePesee ) );
    this._view.backWithMessage(message);
  }

}