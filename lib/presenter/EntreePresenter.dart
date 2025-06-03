import 'package:flutter_gismo/Mouvement/EntreePage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/services/MouvementService.dart';
import 'package:intl/intl.dart';

class EntreePresenter {
  final EntreeService _service = EntreeService();
  final EntreeContract _view;

  EntreePresenter(this._view);


  void save(String ? dateEntree, String ? motif, List<Bete> sheeps) async {
    if (dateEntree == null)
      throw MissingDate();
    if (dateEntree.isEmpty) {
      throw MissingDate();
    }

    if ( motif == null) {
      throw MissingMotif();
    }
    if (motif.isEmpty) {
      throw MissingMotif();
    }
    if (sheeps.length == 0) {
      throw MissingSheeps();
    }
    String message  = await this._service.save(DateFormat.yMd().parse(dateEntree), motif, sheeps);
    this._view.backWithMessage(message);
  }

}

class MissingDate implements Exception {}

class MissingMotif implements Exception {}

class MissingSheeps implements Exception {}