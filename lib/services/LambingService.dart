import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/repository/LambRepository.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LambingService {
  final ConfigProvider _provider = Provider.of<ConfigProvider>(
      NavigationService.navigatorKey.currentContext!, listen: false);
  late LambRepository _lambRepository;

  LambingService() {
    if (_provider.isSubscribing()) {
      _lambRepository = WebLambRepository(_provider.getToken());
    }
    else {
      _lambRepository = LocalLambRepository();
    }
  }

  Future<String ?> saveLambing(LambingModel lambing) async {
    if (lambing.lambs.isEmpty)
      throw NoLamb();
    String ? message = await this._lambRepository.saveLambing(lambing);
    return message;
  }

  Future<String> saveLamb(LambModel lamb) {
    return this._lambRepository.saveLamb(lamb);
  }

  Future<String ?> boucler(LambModel lamb, Bete bete) {
    bete.cheptel = this._provider.getCheptel()!;
    return this._lambRepository.boucler(lamb, bete);
  }

  Future<String> mort(LambModel lamb, String motif, String date) async{
    try {
      await this._lambRepository.mort(lamb, motif, date);
      return "Enregistrement effectué";
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Exception";
    }
  }

  Future<List<Bete>> getLotBeliers(LambingModel lambing) {
    return this._lambRepository.getLotBeliers(lambing);
  }

  Future<List<Bete>> getSaillieBeliers(LambingModel lambing) {
    return this._lambRepository.getSaillieBeliers(lambing);
  }

}

class NoLamb implements Exception {}