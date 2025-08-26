import 'package:flutter_gismo/Lot/presenter/LotAffectationPresenter.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/repository/LotRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';

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
    try {
      return this._lotRepository.addBete(lot, bete);
    }
    on GismoException catch(e) {
      throw e;
    }
  }

  Future<List<LotModel>> getLots() {
    return this._lotRepository.getLots(AuthService().cheptel!);
  }

  Future<LotModel ?> saveLot(LotModel lot) async {
    if (lot.dateDebutLutte == null)
      throw DateDebutException();
    if (lot.dateDebutLutte == "") {
      throw DateDebutException();
    }
    if (lot.dateDebutLutte!.year.toString() != lot.campagne) {
      throw new DebutCampagneException();
    }
    if (lot.dateFinLutte == null)
      throw DateFinException();
    if (lot.dateFinLutte == "") {
      throw DateFinException();
    }
    if (lot.codeLotLutte == null)
      throw CodeLotException();
    if (lot.codeLotLutte == "") {
      throw CodeLotException();
    }
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

  Future<String> updateAffectation(Affectation affect) {
    return this._lotRepository.updateAffectation(affect);
  }

  Future<String> updateAffectationInLot(List<Affectation> toAdd, List<Affectation> toRemove) async {
    return this._lotRepository.updateAffectationInLot(toAdd, toRemove);
  }
}