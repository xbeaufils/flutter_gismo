import 'package:flutter_gismo/individu/EchoPage.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/services/EchoService.dart';
import 'package:intl/intl.dart';

class EchoPresenter {
  final EchoContract _view;
  final EchoService _service = EchoService();
  EchoPresenter(this._view);

  void delete () async {
    if (this._view.currentEcho != null) {
      var message  = await _service.delete(this._view.currentEcho!);
      _view.backWithMessage(message);
    }
    else
      _view.back();
  }

  void saveEcho( String dateEcho, String dateSaillie, String dateAgnelage, int nombre) async {
    if (this._view.currentEcho == null)
      this._view.currentEcho = new EchographieModel();
    this._view.currentEcho!.bete_id = this._view.bete!.idBd!;
    this._view.currentEcho!.dateEcho = DateFormat.yMd().parse(dateEcho);
    this._view.currentEcho!.nombre = nombre;
    if (dateSaillie.isNotEmpty)
      this._view.currentEcho!.dateSaillie = DateFormat.yMd().parse(dateSaillie);
    else
      this._view.currentEcho!.dateSaillie = null;
    if (dateAgnelage.isNotEmpty )
      this._view.currentEcho!.dateAgnelage = DateFormat.yMd().parse(dateAgnelage);
    else
      this._view.currentEcho!.dateAgnelage = null;
    String message = await this._service.save(this._view.currentEcho!);
    this._view.backWithMessage(message);
  }

}