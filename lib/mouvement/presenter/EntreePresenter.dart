import 'package:flutter_gismo/lamb/ui/Bete.dart';
import 'package:flutter_gismo/mouvement/ui/EntreePage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/services/MouvementService.dart';
import 'package:intl/intl.dart';

class EntreePresenter {
  final EntreeService _service = EntreeService();
  final EntreeContract _view;

  EntreePresenter(this._view);


  void save(String ? dateEntree, String ? motif) async {
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
    if (this._view.sheeps.length == 0) {
      throw MissingSheeps();
    }
    String message  = await this._service.save(DateFormat.yMd().parse(dateEntree), motif, this._view.sheeps);
    this._view.backWithMessage(message);
  }

  Future add() async {
    Bete? selectedBete = await this._view.goNextPage( BetePage(null));
    if (selectedBete != null) {
        this._view.sheeps.add(selectedBete);
    }
  }

  void remove(int index) {
    this._view.sheeps.removeAt(index);
  }

}

class MissingDate implements Exception {}

class MissingMotif implements Exception {}

class MissingSheeps implements Exception {}