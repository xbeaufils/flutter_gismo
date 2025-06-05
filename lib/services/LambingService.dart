import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/repository/LambRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LambingService {
  late LambRepository _lambRepository;

  LambingService() {
    if (AuthService().subscribe ) {
      _lambRepository = WebLambRepository(AuthService().token);
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
    bete.cheptel = AuthService().cheptel!;
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

  Future<String> deleteLamb(LambModel lamb ) async {
    return this._lambRepository.deleteLamb(lamb.idBd!);
  }

  Future<List<CompleteLambModel>> getAllLambs() {
    return this._lambRepository.getAllLambs(AuthService().cheptel!);
  }


}

class NoLamb implements Exception {}