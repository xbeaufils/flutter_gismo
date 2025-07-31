
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/parcelle/ui/PaturagePage.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:flutter_gismo/services/ParcelleService.dart';
import 'dart:developer' as debug;

import 'package:intl/intl.dart';

class PaturagePresenter {
  LotService  _lotService = LotService();
  ParcelleService _service = ParcelleService();
  PaturageContract _view;

  PaturagePresenter(this._view);

  Future<List<LotModel>> getLots()  {
    return _lotService.getLots();
  }

  void save(String debut, String ? fin ) async {
    debug.log("Message", name: "PaturagePresenter::_save");
    if (this._view.currentLotId != null)
      this._view.pature.lotId = this._view.currentLotId!;
    this._view.pature.debut = DateFormat.yMd().parse(debut);
    if ( fin != null)
      this._view.pature.fin = DateFormat.yMd().parse(fin);
    String message = await this._service.savePature(this._view.pature);
    this._view.backWithMessage(message);
  }

}