import 'package:flutter_gismo/Exception/EventException.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/repository/LambRepository.dart';
import 'package:flutter_gismo/repository/PeseeRepository.dart';
import 'package:flutter_gismo/repository/TraitementRepository.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'dart:developer' as debug;

class LambingService {
  late LambRepository _lambRepository;
  late PeseeRepository _peseeRepository;
  late Traitementrepository _traitementrepository;

  LambingService() {
    if (AuthService().subscribe ) {
      _lambRepository = WebLambRepository(AuthService().token);
      _peseeRepository = WebPeseeRepository(AuthService().token);
      _traitementrepository = WebTraitementRepository(AuthService().token);
    }
    else {
      _lambRepository = LocalLambRepository();
      _peseeRepository = LocalPeseeRepository();
      _traitementrepository = LocalTraitementRepository();
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

  Future<List<Event>> getEvents(LambModel lamb) async {
    try {
      List<Event> lstEvents = [];
      debug.log("get traitements", name: "BeteService::getEvents");
      List<TraitementModel> lstTraitement = await this._traitementrepository.getTraitements(lamb);
      debug.log("get pesee", name: "BeteService::getEvents");
      List<Pesee> lstPoids  = await this._peseeRepository.getPesee(lamb);
      lstTraitement.forEach( (traitement)  {lstEvents.add(new Event(traitement.idBd!, EventType.traitement, traitement.debut, traitement.medicament));});
      lstPoids.forEach( (poids)  {lstEvents.add(new Event(poids.id!, EventType.pesee, poids.datePesee, poids.poids.toString()));});
      lstEvents.sort((a, b) =>  _compareDate(a, b));
      return lstEvents;
    }
    catch(e, stackTrace) {
      Sentry.captureException(e,stackTrace: stackTrace);
    }
    throw EventException("");
  }
  int _compareDate(Event a, Event b) {
    return b.date.compareTo( a.date);
  }

}

class NoLamb implements Exception {}