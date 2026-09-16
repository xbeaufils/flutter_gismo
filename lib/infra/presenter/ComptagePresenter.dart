import 'package:flutter_gismo/infra/ui/Comptage.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/LotService.dart';

class ComptagePresenter {
  WelcomeContract _view;

  ComptagePresenter(this._view);

  LotService  _lotService = LotService();
  BeteService _beteService = BeteService();

  List<Bete> _countedBetes = [];
  List<Bete> _allBetes = [];

  Future<List<LotModel>> getLots()  {
    return _lotService.getLots();
  }

  Future<List<Bete>> getBetes() async {
      if (_view.currentLotId != null) {
        List<Affectation> beliers = await _lotService.getBeliersForLot(this._view.currentLotId!);
        beliers.forEach((belier) {
          _allBetes.add(Bete.fromAffectation(belier));
        });
        List<Affectation> brebis = await _lotService.getBrebisForLot(this._view.currentLotId!);
        brebis.forEach((brebis) {
          _allBetes.add(Bete.fromAffectation(brebis));
        });
        _allBetes.sort((bete1 , bete2) => bete1.numBoucle.compareTo(bete2.numBoucle));
      }
      else
        _allBetes = await _beteService.getBetes();
      return _allBetes;
  }

  void countBete(Bete bete) {
    _countedBetes.add(bete);
  }
}