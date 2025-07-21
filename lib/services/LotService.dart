import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/repository/LotRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:intl/intl.dart';

class LotService {
  late LotRepository _lotRepository;

  LotService() {
    if (AuthService().subscribe ) {
      _lotRepository  = WebLotRepository(AuthService().token);
    }
    else {
      _lotRepository = LocalLotRepository();
    }
  }

  Future<String> addBete(LotModel lot, Bete bete) {
    return this._lotRepository.addBete(lot, bete);
  }

  Future<String> removeFromLot(Affectation affect, String dateSortie) {
    if (dateSortie.isEmpty)
      affect.dateSortie = null;
    else
      affect.dateSortie = DateFormat.yMd().parse(dateSortie);
    return this._lotRepository.remove(affect);
  }
  Future<List<LotModel>> getLots() {
    return this._lotRepository.getLots(AuthService().cheptel!);
  }

  Future<LotModel ?> saveLot(LotModel lot) async {
    lot.cheptel = AuthService().cheptel;
    LotModel ? newLot  = await this._lotRepository.saveLot(lot);
    return newLot;
  }

  Future<String> deleteLot(LotModel lot) {
    return this._lotRepository.deleteLot(lot);
  }

  Future<List<Affectation>> getBeliersForLot(int idLot) {
    return this._lotRepository.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> getBrebisForLot(int idLot) {
    return this._lotRepository.getBrebisForLot(idLot);
  }

  Future<String> deleteAffectation(Affectation affect) {
    return this._lotRepository.deleteAffectation(affect);
  }

  Future<String> updateAffectationInLot(List<Affectation> toAdd, List<Affectation> toRemove) async {
    return this._lotRepository.updateAffectationInLot(toAdd, toRemove);
  }
}