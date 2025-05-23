import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/repository/LotRepository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LotService {
  late LotRepository _lotRepository;
  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);

  LotService() {
    if (_provider.isSubscribing()) {
      _lotRepository  = WebLotRepository(_provider.getToken());
    }
    else {
      _lotRepository = LocalLotRepository();
    }
  }

  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) {
    return this._lotRepository.addBete(lot, bete, dateEntree);
  }

  Future<String> removeFromLot(Affectation affect, String dateSortie) {
    affect.dateSortie = DateFormat.yMd().parse(dateSortie);
    return this._lotRepository.remove(affect);
  }

  Future<LotModel ?> saveLot(LotModel lot) async {
    lot.cheptel = this._provider.getCheptel();
    LotModel ? newLot  = await this._lotRepository.saveLot(lot);
    return newLot;
  }

  Future<List<Affectation>> getBeliersForLot(int idLot) {
    return this._lotRepository.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> getBrebisForLot(int idLot) {
    return this._lotRepository.getBrebisForLot(idLot);
  }


}