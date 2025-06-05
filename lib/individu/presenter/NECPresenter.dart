import 'package:flutter_gismo/individu/ui/NECPage.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/services/NECService.dart';
import 'package:intl/intl.dart';

class NECPresenter {
  final NECContract _view;
  final NECService _service = NECService();
  NECPresenter(this._view);

  void saveNote(String dateNote, int _nec) async {
    this._view.showSaving();
    /*setState(() {
      _isSaving = true;
    });*/
    String message = await this._service.saveNec(this._view.bete,  NEC.getNEC(_nec), DateFormat.yMd().parse(dateNote));
    this._view.backWithMessage(message);
  }

}