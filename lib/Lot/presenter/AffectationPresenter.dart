import 'package:flutter_gismo/Lot/ui/AffectationPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:intl/intl.dart';

class AffectationPresenter {

  final LotService service = LotService();

  final AffectationContract _view;

  AffectationPresenter(this._view);

  void save(String dateEntree, String dateSortie) {
    this._view.currentAffectation.dateEntree = DateFormat.yMd().parse(dateEntree);
    this._view.currentAffectation.dateSortie = DateFormat.yMd().parse(dateSortie);
    service.updateAffectation(this._view.currentAffectation);
    this._view.backWithObject(this._view.currentAffectation);
  }
}